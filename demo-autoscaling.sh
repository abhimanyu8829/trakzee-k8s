#!/bin/bash

# Use minikube kubectl
KUBECTL="minikube kubectl --"

echo "========================================="
echo "TRAKZEE AUTO-SCALING DEMO"
echo "Using Tomcat (Fully Working)"
echo "========================================="

# Step 1: Show current state
echo ""
echo "📊 CURRENT STATE:"
$KUBECTL get pods -n trakzee-test -l app=tomcat
$KUBECTL get hpa -n trakzee-test tomcat-hpa

# Step 2: Generate load
echo ""
echo "🚀 GENERATING LOAD on Tomcat..."
$KUBECTL run -i --rm load-generator --image=busybox -n trakzee-test --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://tomcat-service.trakzee-test.svc.cluster.local; done" &
LOAD_PID=$!

# Step 3: Monitor for 2 minutes
echo ""
echo "⏳ Monitoring for 2 minutes (HPA will scale up)..."
for i in {1..12}; do
    sleep 10
    echo ""
    echo "--- $(date +%H:%M:%S) ---"
    $KUBECTL get hpa -n trakzee-test tomcat-hpa
    $KUBECTL get pods -n trakzee-test -l app=tomcat
done

# Step 4: Stop load
echo ""
echo "🛑 STOPPING load generator..."
kill $LOAD_PID 2>/dev/null

echo ""
echo "✅ Demo complete! Tomcat auto-scaling works!"

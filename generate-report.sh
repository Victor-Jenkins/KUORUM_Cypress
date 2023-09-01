#!/bin/bash

# Ejecutar pruebas de Cypress y guardar logs
npx cypress run 2>&1 | tee cypress-logs.txt || true

# Contar resultados de las pruebas
passed=$(grep -oP '✔.*\d+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+' cypress-logs.txt | awk '{ sum += $4 } END { print sum }')
failed=$(grep -oP '✔.*\d+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+' cypress-logs.txt | awk '{ sum += $5 } END { print sum }')
skipped=$(grep -oP '✔.*\d+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+\s+[\d-]+' cypress-logs.txt | awk '{ sum += $6 } END { print sum }')
total=$((passed + failed + skipped))
passed_percent=$((passed * 100 / total))
failed_percent=$((failed * 100 / total))
skipped_percent=$((skipped * 100 / total))

# Generar informe HTML
cat <<EOF >cypress-report.html
<!DOCTYPE html>
<html>
<head>
<style>
  body {
    font-family: Arial, sans-serif;
    background-color: #2a2a2a;
    color: white;
  }
  .header {
    padding: 20px;
    background-color: #1a1a1a;
    text-align: center;
  }
  .report-title {
    font-size: 24px;
    margin-bottom: 10px;
  }
  .log-container {
    background-color: #1a1a1a;
    padding: 20px;
  }
  pre {
    background-color: #1a1a1a;
    border: none;
    color: white;
  }
  .chart-container {
    text-align: center;
    margin-top: 20px;
  }
  canvas {
    background-color: #1a1a1a;
  }
</style>
</head>
<body>
<div class='header'>
  <h1 class='report-title'>Cypress Test Report</h1>
</div>
<div class='log-container'>
  <pre>
$(cat cypress-logs.txt | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
  </pre>
</div>
<div class='chart-container'>
  <canvas id='chart'></canvas>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
const passedPercent = ${passed_percent};
const failedPercent = ${failed_percent};

const ctx = document.getElementById('chart').getContext('2d');

new Chart(ctx, {
  type: 'doughnut',
  data: {
    labels: ['Passed', 'Failed'],
    datasets: [{
      data: [passedPercent, failedPercent],
      backgroundColor: ['#36A2EB', '#FF6384'],
    }]
  },
  options: {
    title: {
      display: true,
      text: 'Test Results',
      fontSize: 16,
    }
  }
});
</script>
</body>
</html>
EOF

echo "Informe HTML generado: cypress-report.html"

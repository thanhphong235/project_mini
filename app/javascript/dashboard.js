document.addEventListener("turbo:load", () => {
  initLineChart();
  initBarChart();
  initDonutChart();
});

function initLineChart() {
  const el = document.getElementById("lineChart");
  if (!el) return;

  const values = safeJSON(el.dataset.values);
  const labels = safeJSON(el.dataset.labels);

  new Chart(el, {
    type: "line",
    data: {
      labels: labels.length ? labels : [],
      datasets: [{
        label: "Doanh thu",
        data: values,
        borderColor: "#36A2EB",
        borderWidth: 2,
        fill: false
      }]
    }
  });
}

function initBarChart() {
  const el = document.getElementById("barChart");
  if (!el) return;

  const values = safeJSON(el.dataset.values);
  const labels = safeJSON(el.dataset.labels);

  new Chart(el, {
    type: "bar",
    data: {
      labels: labels.length ? labels : [],
      datasets: [{
        label: "Số đơn hàng",
        data: values,
        backgroundColor: "#FFCE56"
      }]
    }
  });
}


function initDonutChart() {
  const el = document.getElementById("donutChart");
  if (!el) return;

  const labels = safeJSON(el.dataset.labels);
  const values = safeJSON(el.dataset.values);

  if (labels.length === 0) return;

  new Chart(el, {
    type: "doughnut",
    data: {
      labels: labels,
      datasets: [{
        data: values,
        backgroundColor: [
          "#FF6384", "#36A2EB",
          "#FFCE56", "#4BC0C0",
          "#9966FF", "#FF9F40"
        ]
      }]
    }
  });
}

function safeJSON(str) {
  try { return JSON.parse(str || "[]"); }
  catch { return []; }
}

function months() {
  return ["T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12"];
}

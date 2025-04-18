import Chart from "./chart"

const chartsByCanvasId = {};

const destroyChartIfNecessary = (canvasId) => {
  if (chartsByCanvasId[canvasId]) {
    chartsByCanvasId[canvasId].destroy();
  }
}

const registerNewChart = (canvasId, chart) => {
  chartsByCanvasId[canvasId] = chart;
}

export const renderChart = (chartCanvasID, chartType, chartData, chartOptions) => {
  const chartCanvas = document.getElementById(chartCanvasID);
  destroyChartIfNecessary(chartCanvasID);
  const myChart = new Chart(chartCanvas, {
    type: chartType, // Choose the chart type (line, scatter, etc.)
    data: chartData,
    options: chartOptions
  });
  registerNewChart(chartCanvasID, myChart);
};

export const clearChartCanvas = (chartCanvasID) => {
  const chartCanvas = document.getElementById(chartCanvasID);
  let ctx = chartCanvas.getContext('2d');
  ctx.clearRect(0, 0,
    chartCanvas.width, chartCanvas.height);
};

import * as chartHelper from '../chartHelper'

export const Chart = {
  mounted() {
    console.log("mounted");
    console.log(this.el.dataset.chartConfig);
    if (this.el.dataset.chartConfig) {
      const chartConfig = JSON.parse(this.el.dataset.chartConfig);
      chartHelper.renderChart('price-chart-canvas', chartConfig.type, chartConfig.chartData, chartConfig.chartOptions);
    }
  },

  updated() {
    console.log("updated");
    if (this.chart) {
      this.chart.destroy();
    }

    if (this.el.dataset.chartConfig) {
      const chartConfig = JSON.parse(this.el.dataset.chartConfig);
      this.chart = chartHelper.renderChart(
        "price-chart-canvas",
        chartConfig.type,
        chartConfig.chartData,
        chartConfig.chartOptions
      );
    }
  }
  ,
  destroyed() {
    console.log("from hook destroyed");
    this.chart.destroy();
  }
};

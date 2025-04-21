function crearGraficaProductos(data) {
    Highcharts.chart('container', {
        chart: {
            type: 'column',
            options3d: {
                enabled: true,
                alpha: 10,
                beta: 25,
                depth: 70
            }
        },
        title: {
            text: 'Productos M\u00e1s Vendidos'
        },
        subtitle: {
            text: 'Entre las fechas seleccionadas'
        },
        plotOptions: {
            column: {
                depth: 25
            }
        },
        xAxis: {
            type: 'category',
            labels: {
                skew3d: true,
                style: {
                    fontSize: '14px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Unidades Vendidas'
            }
        },
        tooltip: {
            valueSuffix: ' unidades'
        },
        series: [{
                name: 'Productos',
                data: data
            }]
    });
}

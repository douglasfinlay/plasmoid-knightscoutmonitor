import QtQuick 2.0

Canvas {
    id: glucoseChartCanvas

    anchors.fill: parent

    antialiasing: true

    property ListModel glucoseReadings: root.previousGlucoseReadings

    property int glucoseRangeMin: 36
    property int glucoseRangeMax: 288

    property int glucoseRegionHigh: 180
    property int glucoseRegionLow: 90

    property int timeRangeMin: 0
    property int timeRangeMax: 100

    property color glucosePointInRangeColor: 'slategray'
    property color glucosePointLowColor: 'orange'
    property color glucosePointHighColor: 'yellow'

    property color regionDivisionColor: 'grey'
    property int regionDivisionThickness: 1

    readonly property int pointSize: 4

    Timer {
        id: graphAxisRangeUpdateTimer
        interval: 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var threeHoursAgo = new Date();
            threeHoursAgo.setHours(threeHoursAgo.getHours() - 3);
            var now = new Date();

            timeRangeMin = threeHoursAgo.getTime() / 1000;
            timeRangeMax = now.getTime() / 1000;
        }
    }

    onPaint: {
        var ctx = getContext('2d');

        ctx.clearRect(0, 0, width, height);

        paintGlucoseRegionDivisions(ctx);

        for (var i=0; i<glucoseReadings.count; i++) {
            const r = glucoseReadings.get(i)
            plotPoint(ctx, r.glucose, r.time);
        }
    }

    function paintGlucoseRegionDivisions(ctx) {
        ctx.beginPath();

        ctx.strokeStyle = regionDivisionColor;
        ctx.lineWidth = regionDivisionThickness;

        // Low region
        var yCoordLow = yCoordForGlucose(glucoseRegionLow);
        ctx.moveTo(0, yCoordLow);
        ctx.lineTo(width, yCoordLow);

        // High region
        var yCoordHigh = yCoordForGlucose(glucoseRegionHigh);
        ctx.moveTo(0, yCoordHigh);
        ctx.lineTo(width, yCoordHigh);

        ctx.stroke();
    }

    function yCoordForGlucose(glucose) {
        var percent = ((glucose - glucoseRangeMin) / (glucoseRangeMax - glucoseRangeMin));
        return height - percent * height;
    }

    function xCoordForTime(time) {
        var percent = ((time - timeRangeMin) / (timeRangeMax - timeRangeMin));
        return percent * width;
    }

    function plotPoint(ctx, glucose, time) {
        // Ignore the point if it lies outside the x-axis range
        if (time < timeRangeMin || time > timeRangeMax) return;

        var x = xCoordForTime(time) - pointSize/2;
        var y = yCoordForGlucose(glucose) - pointSize/2;

        var color = glucosePointInRangeColor;
        if (glucose > glucoseRegionHigh) {
            color = glucosePointHighColor;
        } else if (glucose < glucoseRegionLow) {
            color = glucosePointLowColor;
        }

        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.fillStyle = color;

        if (glucose > glucoseRangeMax) {
            // Out of display range - draw a triangle pointing up
            ctx.moveTo(x, pointSize);
            ctx.lineTo(x+pointSize, pointSize);
            ctx.lineTo(x + pointSize/2, 0);
            ctx.closePath();
        } else if (glucose < glucoseRangeMin) {
            // Out of display range - draw a triangle pointing down
            ctx.moveTo(x, height-pointSize);
            ctx.lineTo(x+pointSize, height-pointSize);
            ctx.lineTo(x + pointSize/2, height);
            ctx.closePath();
        } else {
            // In range - draw a standard, circular point
            ctx.ellipse(x, y, pointSize, pointSize);
        }

        ctx.fill();
        ctx.stroke();
    }
}

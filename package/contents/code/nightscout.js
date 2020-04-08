function getCurrentReading(ns_url, callback) {
    if (ns_url === null) return false;

    const API_PATH = '/api/v1/entries/current.json';

    var req = new XMLHttpRequest();

    var fireCallback = function (currentGlucose, trendArrow, readingEpoch) {
        if (typeof callback === 'function') {
            callback(currentGlucose, trendArrow, readingEpoch);
        }
    }

    req.onreadystatechange = function () {
        if (req.readyState == XMLHttpRequest.DONE) {
            var currentGlucose = 0;
            var trendArrow = '';

            if (req.status === 200) {
                var jsonResponse = JSON.parse(req.responseText)[0];

                currentGlucose = jsonResponse.sgv;
                var currentGlucoseTrend = jsonResponse.direction;
                trendArrow = directionToArrow(currentGlucoseTrend);
                var readingEpoch = jsonResponse.date;
            }

            fireCallback(currentGlucose, trendArrow, readingEpoch);
        }
    }

    req.onerror = function (pe) {
        fireCallback(0, '');
    }

    var url = ns_url + API_PATH + '?' + Date.now();
    req.open('GET', url, true);
    req.send();

    return true;
}

function getReadingsSince(epoch, ns_url, callback) {
    if (ns_url === null) return false;

    const API_PATH = '/api/v1/entries.json?find[date][$gte]=' + epoch + '&count=10000'

    var req = new XMLHttpRequest();

    var fireCallback = function (readingsList) {
        if (typeof callback === 'function') {
            callback(readingsList);
        }
    }

    req.onreadystatechange = function () {
        if (req.readyState == XMLHttpRequest.DONE) {
            var readingsList = [];

            if (req.status === 200) {
                readingsList = JSON.parse(req.responseText);
            }

            fireCallback(readingsList);
        }
    }

    req.onerror = function (pe) {
        fireCallback(null);
    }

    req.open('GET', ns_url + API_PATH, true);
    req.send();

    return true;
}

function directionToArrow(direction) {
    switch (direction) {
        case 'Flat':
            return '→';
        case 'FortyFiveUp':
            return '↗';
        case 'SingleUp':
            return '↑';
        case 'DoubleUp':
            return '⇈';
        case 'FortyFiveDown':
            return '↘';
        case 'SingleDown':
            return '↓';
        case 'DoubleDown':
            return '⇊';
        default:
            return '·';
    }
}

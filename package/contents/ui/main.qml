import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

import '../code/nightscout.js' as NS

Item {
    id: root

    property int currentGlucoseMgdl: 0
    property string currentGlucoseText: ''
    property string glucoseTrendArrow: ''
    property bool currentGlucoseValid: false
    property date currentGlucoseTimestamp: new Date(0)

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation {}

    Component.onCompleted: {
        updateCurrentGlucoseText();
        updateToolTipSubText();
    }

    Connections {
        target: plasmoid.configuration

        onNsURLChanged: {
            glucoseUpdateTimer.restart();
        }

        onNsUpdateIntervalChanged: {
            glucoseUpdateTimer.restart();
        }

        onUseMmolChanged: {
            updateCurrentGlucoseText();
        }
    }

    onCurrentGlucoseMgdlChanged: {
        // The current reading is invalid if 0
        currentGlucoseValid = (currentGlucoseMgdl !== 0);
        updateCurrentGlucoseText();
    }

    onCurrentGlucoseTimestampChanged: {
        updateToolTipSubText();
    }

    Timer {
        id: glucoseUpdateTimer
        interval: plasmoid.configuration.nsUpdateInterval * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            // Don't attempt to update if the Nightscout URL isn't set
            if (!plasmoid.configuration.nsURL) return;

            glucoseUpdateTimeout.start();

            var result = NS.getCurrentGlucose(plasmoid.configuration.nsURL, function(level, trend, epoch) {
                root.currentGlucoseMgdl = level;
                root.glucoseTrendArrow = trend;
                root.currentGlucoseTimestamp = new Date(epoch);
                glucoseUpdateTimeout.stop();
            });
        }
    }

    Timer {
        id: glucoseUpdateTimeout
        interval: 5 * 1000
        repeat: false
        onTriggered: {
            root.currentGlucoseMgdl = 0;
        }
    }

    function updateCurrentGlucoseText() {
        var text = '';
        var levelMgdl = root.currentGlucoseMgdl;
        var useMmol = plasmoid.configuration.useMmol;

        if (levelMgdl == 0) {
            text += '---';
        } else {
            text += useMmol ? (levelMgdl/18).toFixed(1) : levelMgdl;
        }

        text += ' ';
        text += useMmol ? 'mmol/L' : 'mg/dL';

        root.currentGlucoseText = text;
    }

    //
    // Tooltips
    //
    Plasmoid.toolTipMainText: i18n('KNightscout Monitor')
    Plasmoid.toolTipSubText: ''

    function updateToolTipSubText() {
        var t = root.currentGlucoseTimestamp;
        if (t.getTime() === 0) {
            Plasmoid.toolTipSubText = 'No readings';
        } else {
            // TODO: timezone!?
            Plasmoid.toolTipSubText = 'Last reading at ' + t.toLocaleTimeString(Qt.locale(), Locale.ShortFormat);
        }
    }
}

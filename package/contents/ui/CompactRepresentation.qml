import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: container

    Layout.minimumWidth: contentItem.width + 8
    Layout.maximumWidth: Layout.minimumWidth + 8
    Layout.fillWidth: false

    MouseArea {
        anchors.fill: parent
        onClicked: plasmoid.expanded = !plasmoid.expanded
    }

    states: State {
        name: 'currentGlucoseInvalid'
        when: !root.currentGlucoseValid
        PropertyChanges {
            target: currentGlucoseLabel
            color: PlasmaCore.ColorScope.disabledTextColor
        }
        PropertyChanges {
            target: glucoseTrendLabel
            opacity: 0
        }
    }

    transitions: Transition {
        from: ''
        to: 'currentGlucoseInvalid'
        reversible: true
        ParallelAnimation {
            ColorAnimation { duration: 300 }
            PropertyAnimation {
                properties: 'opacity'
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }

    Item {
        id: contentItem

        width: currentGlucoseLabel.paintedWidth + glucoseTrendLabel.paintedWidth

        Row {
            spacing: 5

            PlasmaComponents.Label {
                id: currentGlucoseLabel
                text: root.currentGlucoseText

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter

                Layout.fillWidth: true
                Layout.minimumWidth: currentGlucoseLabel.contentWidth
            }

            PlasmaComponents.Label {
                id: glucoseTrendLabel
                text: root.glucoseTrendArrow

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                Layout.fillWidth: true
                Layout.minimumWidth: glucoseTrendLabel.contentWidth
            }
        }
    }
}

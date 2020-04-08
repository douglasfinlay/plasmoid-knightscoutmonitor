import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kirigami 2.8 as Kirigami

Item {
    id: chartView

    Layout.minimumWidth: 500
    Layout.minimumHeight: 200
    Layout.preferredWidth: 500
    Layout.preferredHeight: 200

    GlucoseChart {
        id: clucoseChart

        glucosePointInRangeColor: Kirigami.Theme.positiveTextColor
        glucosePointLowColor: Kirigami.Theme.negativeTextColor
        glucosePointHighColor: Kirigami.Theme.neutralTextColor
        regionDivisionColor: Kirigami.Theme.disabledTextColor
    }
}

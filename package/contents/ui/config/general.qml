import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0 as QtDialogs

import org.kde.kquickcontrols 2.0 as KQC
import org.kde.kirigami 2.8 as Kirigami

Kirigami.FormLayout {
    id: generalPage

    width: childrenRect.Width
    height: childrenRect.Height

    property alias cfg_nsURL: nsURL.text
    property alias cfg_nsUpdateInterval: nsUpdateInterval.value
    property alias cfg_useMmol: useMmol.checked

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        TextField {
            id: nsURL
            Kirigami.FormData.label: i18n("Nightscout")
            placeholderText: i18n("your-nightscout.herokuapp.com")
        }

        SpinBox {
            id: nsUpdateInterval
            Kirigami.FormData.label: i18n("Udpate Interval")
            editable: true
            from: 30
            to: 10 * 60
            textFromValue: function(val) {
                return val + " s";
            }
            valueFromText: function(text) {
                // Strip any non-digits from the string
                return parseInt(text.replace(/[^\d]/g, ''), 10);
            }
        }

        CheckBox {
            id: useMmol
            Kirigami.FormData.label: i18n("Show Level in mmol/L")
        }
    }
}
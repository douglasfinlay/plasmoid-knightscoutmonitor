import QtQuick 2.0

import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18nc("@title", "General")
        icon: "preferences-system-windows"
        source: "config/general.qml"
    }
}
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    property var pluginApi: null

    Logger {
        id: logger
        name: "CalendarPlugin"
    }

    // This object links your UI to the settings system
    // It will automatically look for settings.json or use manifest defaults
    JsonSettings {
        id: calendarSettings
        source: Qt.resolvedUrl("settings.json")
        defaults: { "startOnMonday": true }
    }

    Component.onCompleted: {
        if (pluginApi && pluginApi.registerDesktopWidget) {
            pluginApi.registerDesktopWidget(
                "calendar-widget",
                "Monthly Calendar",
                "calendar-month",
                Qt.resolvedUrl("DesktopWidget.qml"),
                Qt.resolvedUrl("Settings.qml") // Pass it here too for double-assurance
            );
            logger.info("Calendar widget registered with settings support.");
        }
    }
}

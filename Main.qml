import QtQuick
import Quickshell
import Quickshell.Io // Required for Logger

Item {
    id: root
    
    property var pluginApi: null

    // Initialize the logger
    Logger {
        id: logger
        name: "CalendarPlugin" // This helps identify where the log came from
    }


}

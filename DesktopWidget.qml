import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets

DraggableDesktopWidget {
    id: root
    property var pluginApi: null

    // --- Sizing ---
    readonly property real _width: Math.round(250 * widgetScale)
    readonly property real _height: Math.round(285 * widgetScale)
    implicitWidth: _width
    implicitHeight: _height

    // --- Date Logic ---
    // Changed from readonly to property so it can be updated
    property date currentDate: new Date()
    
    function refreshDate() {
        currentDate = new Date();
    }

    // Auto-refresh every minute to catch the date change at midnight
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.refreshDate()
    }

    readonly property var days: ["M", "T", "W", "T", "F", "S", "S"]
    
    readonly property int firstDayOffset: {
        let firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
        return (firstDay === 0) ? 6 : firstDay - 1;
    }
    readonly property int daysInMonth: new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate()
    
    // Check if a specific day is "Today" based on system time vs calendar state
    function isToday(dayNum) {
        let now = new Date();
        return dayNum === now.getDate() && 
               currentDate.getMonth() === now.getMonth() && 
               currentDate.getFullYear() === now.getFullYear();
    }

    // --- UI Layout ---
    Rectangle {
        anchors.fill: parent
        color: Color.mSurface 
        opacity: 0.85
        radius: Style.radiusM
        border.color: Color.mOutlineVariant
        border.width: 1

// --- Themed Refresh Button (Vector Drawn) ---
        Rectangle {
            id: refreshBtn
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: Style.marginS
            width: 32 * widgetScale
            height: 32 * widgetScale
            radius: Style.radiusS
            // Uses your theme's container color on hover, transparent otherwise
            color: mouseArea.containsMouse ? Color.mPrimaryContainer : "transparent"
            
            Behavior on color { ColorAnimation { duration: 150 } }

            
            Canvas {
                id: refreshIcon
                anchors.fill: parent
                anchors.margins: 8 * widgetScale
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = mouseArea.containsMouse ? Color.mOnPrimaryContainer : Color.mPrimary;
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    // Draw a 3/4 circle arc
                    ctx.arc(width/2, height/2, width/2 - 2, 0, Math.PI * 1.5);
                    ctx.stroke();
                    // Draw the arrowhead
                    ctx.fillStyle = ctx.strokeStyle;
                    ctx.beginPath();
                    ctx.moveTo(width/2, 0);
                    ctx.lineTo(width/2 + 4, 4);
                    ctx.lineTo(width/2 - 4, 4);
                    ctx.closePath();
                    ctx.fill();
                }
                
                // Redraw if the color changes on hover
                Connections {
                    target: mouseArea
                    function onContainsMouseChanged() { refreshIcon.requestPaint(); }
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.refreshDate()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.marginL
            spacing: Style.marginS

            // Month and Year Header
            NText {
                text: currentDate.toLocaleDateString(Qt.locale(), "MMMM yyyy").toUpperCase()
                color: Color.mPrimary 
                font.bold: true
                font.letterSpacing: 1.2
                font.pointSize: Style.fontSizeM
                Layout.alignment: Qt.AlignHCenter
            }

            // Calendar Grid
            GridLayout {
                columns: 7
                rowSpacing: Style.marginS
                columnSpacing: Style.marginS
                Layout.fillWidth: true

                // 1. Day Headers
                Repeater {
                    model: root.days
                    NText {
                        text: modelData
                        color: Color.mOnSurfaceVariant
                        font.bold: true
                        font.pointSize: Style.fontSizeS
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // 2. Padding
                Repeater {
                    model: root.firstDayOffset
                    Item { Layout.preferredWidth: 20 * widgetScale; Layout.preferredHeight: 20 * widgetScale }
                }

                // 3. The Days
                Repeater {
                    model: root.daysInMonth
                    Rectangle {
                        readonly property int dayNum: index + 1
                        readonly property bool highlight: root.isToday(dayNum)
                        
                        Layout.preferredWidth: 28 * widgetScale
                        Layout.preferredHeight: 28 * widgetScale
                        
                        color: highlight ? Color.mPrimary : "transparent"
                        radius: Style.radiusS

                        NText {
                            anchors.centerIn: parent
                            text: dayNum
                            color: highlight ? Color.mOnPrimary : Color.mOnSurface
                            font.bold: highlight
                            font.pointSize: Style.fontSizeS
                        }
                    }
                }
            }
        }
    }
}

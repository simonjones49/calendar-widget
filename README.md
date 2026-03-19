# Calendar Widget

A compact, elegant Noctalia bar widget that displays the current date and time. It provides a quick expansion view for monthly planning and event tracking.

## Features
- **Dynamic Clock**: Localized time display with support for 12h/24h formats.
- **Interactive Calendar**: Clicking the widget expands a full-month view.
- **Event Highlights**: (Optional) Integrates with local calendars to mark busy days.

## Installation
Clone this repo into your Noctalia plugins directory:
\`~/.config/noctalia/plugins/calendar-widget\`

## Configuration
- **Date Format**: Custom strftime-style formatting for the bar display.
- **First Day of Week**: Toggle between Sunday or Monday start.
- **Show Seconds**: Toggle for the clock display.

## Requirements
- **Noctalia Shell**: 3.6.0 or later.
- **Fonts**: Requires a monospace or icon-compatible font for proper alignment.

## Technical Details
- **Implementation**: Native QML Date/Time objects for high efficiency.
- **Localization**: Respects the system $LANG and LC_TIME environment variables.

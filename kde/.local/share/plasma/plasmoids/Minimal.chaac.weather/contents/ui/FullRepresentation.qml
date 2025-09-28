import QtQuick
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid
import org.kde.plasma.components 3.0 as PlasmaComponents3
import "components" as Components
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: fullweather
    width: 350
    height: 290

    Components.WeatherData {
        id: weatherData
    }

    property int temperatureUnit: Plasmoid.configuration.temperatureUnit

    function sumarDia(a) {
        var currentDay = (new Date()).getDay()
        var day = ((currentDay + a) % 7 ) === 7 ? 0 : (currentDay + a) % 7
        return day
    }


    property string tomorrow: sumarDia(1)
    property string dayAftertomorrow: sumarDia(2)
    property string twoDaysAfterTomorrow: sumarDia(3)




    Item {
        id: currentWeather
        width: parent.width
        height: parent.height / 2
        Column {
            width: longweathertext.implicitWidth < temperatura.implicitWidth ? temperatura.implicitWidth : longweathertext.implicitWidth
            height: temperatura.implicitHeight + longweathertext.implicitHeight
            anchors.centerIn: currentWeather
            spacing: 0
            PlasmaComponents3.Label {
                id: temperatura
                text: temperatureUnit === 0 ? Math.round(weatherData.temperaturaActual) + "°C" : Math.round(weatherData.temperaturaActual) + "°F"
                width: parent.width
                font.pixelSize: currentWeather.height * 0.4
                horizontalAlignment: Text.AlignHCenter
            }
            PlasmaComponents3.Label {
                id: longweathertext
                text: weatherData.weatherLongtext
                width: parent.width
                font.pixelSize: currentWeather.height * .18
                horizontalAlignment: Text.AlignHCenter
            }
            PlasmaComponents3.Label {
                text: weatherData.textProbability + ": " + weatherData.probabilidadDeLLuvia + "%"
                width: parent.width
                font.pixelSize: currentWeather.height * .09
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Row {
        id: forecastSection
        width: fullweather.width
        height: fullweather.height / 2
        spacing: 0
        Repeater {
            model: 3
            delegate: Column {
                height: parent.height
                width: parent.width/3
                spacing: parent.height / 18

                PlasmaComponents3.Label {
                    width: parent.width
                    text: days[sumarDia((modelData + 1))]
                    horizontalAlignment: Text.AlignHCenter
                }

                Kirigami.Icon {
                    source: weatherData.asingicon(weatherData.codeweatherTomorrow)
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Row {
                    width: max.width + min.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    PlasmaComponents3.Label {
                        id: max
                        text: modelData === 0 ? Math.round(weatherData.maxweatherTomorrow) + "°  " :  modelData === 1  ? Math.round(weatherData.maxweatherDayAftertomorrow) + "° " : modelData === 2 ? Math.round(weatherData.maxweatherTwoDaysAfterTomorrow) + "°  " : ""
                        horizontalAlignment: Text.AlignHCenter
                    }
                    PlasmaComponents3.Label {
                        id: min
                        text:  modelData === 0 ? Math.round(weatherData.minweatherTomorrow) + "°" :  modelData === 1  ? Math.round(weatherData.minweatherDayAftertomorrow) + "°" : modelData === 2 ? Math.round(weatherData.minweatherTwoDaysAfterTomorrow) + "°" : ""
                        opacity: .5
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: {
            tomorrow = sumarDia(1)
            dayAftertomorrow = sumarDia(2)
            twoDaysAfterTomorrow = sumarDia(3)
        }
    }
}

# Weather Check

## About this Project

Weather Check is a REST API that provides information about the weather in a given location. It also utilizes API key authentication to allow users to create a road trip and get information about the weather upon their arrival at their destination.

## Setup

1. Fork and clone the repository
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{create,migrate}`
4. Apply for an API key with [Mapquest](https://developer.mapquest.com/user/login/sign-up) & [Weather API](https://www.weatherapi.com/signup.aspx)
5. Run `bundle exec figaro install` and add the API keys to the `./config/application.yml` file.

    - Save the MapQuest key as `mapquest_api_key`
    - Save the Weather key as `weather_api_key`

## Testing
To run all tests from your command line:
 - run `bundle exec rspec`

 *All tests should be passing*

Happy and sad path cases were accounted for and tested for each endpoint.

Additionally, you can test each endpoint here [![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/26085409-1cb627ef-d500-4f6f-b849-9b655205c7ed?action=collection%2Ffork&collection-url=entityId%3D26085409-1cb627ef-d500-4f6f-b849-9b655205c7ed%26entityType%3Dcollection%26workspaceId%3Df402ed1d-531c-4451-ad21-b6367689bff9)

**NOTE:** *You will need to sign up as a user by visiting the POST '/api/v0/users' endpoint with the correct request body before you will be able to access the road_trip endpoint.*

## Endpoints
<details>
<summary>GET '/api/v0/forecast'</summary>

Request Params:
<pre>
<code>
  location = (location)
</code>
</pre>

Response:
<pre>
<code>
  {
    "data": {
        "id": null,
        "type": "forecast",
        "attributes": {
            "current_weather": {
                "last_updated": "2023-04-25 08:15",
                "temperature": 71.1,
                "feels_like": 71.1,
                "humidity": 13,
                "uvi": 6,
                "visibility": 9,
                "condition": "Sunny",
                "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
            },
            "daily_weather": [
                {
                    "date": "2023-04-25",
                    "sunrise": "05:55 AM",
                    "sunset": "07:23 PM",
                    "max_temp": 85.3,
                    "min_temp": 61.3,
                    "condition": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "date": "2023-04-26",
                    "sunrise": "05:54 AM",
                    "sunset": "07:24 PM",
                    "max_temp": 88.3,
                    "min_temp": 56.7,
                    "condition": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "date": "2023-04-27",
                    "sunrise": "05:52 AM",
                    "sunset": "07:25 PM",
                    "max_temp": 94.8,
                    "min_temp": 60.3,
                    "condition": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "date": "2023-04-28",
                    "sunrise": "05:51 AM",
                    "sunset": "07:26 PM",
                    "max_temp": 95,
                    "min_temp": 65.8,
                    "condition": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "date": "2023-04-29",
                    "sunrise": "05:50 AM",
                    "sunset": "07:27 PM",
                    "max_temp": 95.2,
                    "min_temp": 63,
                    "condition": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                }
            ],
            "hourly_weather": [
                {
                    "time": "00:00",
                    "temperature": 69.3,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "01:00",
                    "temperature": 67.1,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "02:00",
                    "temperature": 65.7,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "03:00",
                    "temperature": 64.4,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "04:00",
                    "temperature": 62.8,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "05:00",
                    "temperature": 61.9,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "06:00",
                    "temperature": 61.3,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "07:00",
                    "temperature": 65.1,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "08:00",
                    "temperature": 68.4,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "09:00",
                    "temperature": 70.3,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "10:00",
                    "temperature": 72.5,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "11:00",
                    "temperature": 74.8,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "12:00",
                    "temperature": 81.5,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "13:00",
                    "temperature": 82.6,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "14:00",
                    "temperature": 83.8,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "15:00",
                    "temperature": 84.9,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "16:00",
                    "temperature": 85.3,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "17:00",
                    "temperature": 84.2,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "18:00",
                    "temperature": 81.7,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "19:00",
                    "temperature": 76.5,
                    "conditions": "Sunny",
                    "icon": "cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                {
                    "time": "20:00",
                    "temperature": 71.6,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "21:00",
                    "temperature": 69.1,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "22:00",
                    "temperature": 67.3,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                },
                {
                    "time": "23:00",
                    "temperature": 66.6,
                    "conditions": "Clear",
                    "icon": "cdn.weatherapi.com/weather/64x64/night/113.png"
                }
            ]
        }
    }
}
</code>
</pre>
</details>

<details>
<summary>POST '/api/v0/users'</summary>

Request Body:
<pre>
<code>
{
    "email": "dogood@gmail.com",
    "password": "awesome",
    "password_confirmation": "awesome"
}
</code>
</pre>

Response:
<pre>
<code>
{
    "data": {
        "id": "6",
        "type": "users",
        "attributes": {
            "email": "dogood@gmail.com",
            "api_key": "913cdfa4c724c60ef5d3f77482d0697c"
        }
    }
}
</code>
</pre>
</details>

<details>
<summary> POST 'api/v0/sessions'</summary>

Request Body:
<pre>
<code>
{
    "email": "dogood@gmail.com",
    "password": "awesome"
}
</code>
</pre>

Response:
<pre>
<code>
{
    "data": {
        "id": "6",
        "type": "users",
        "attributes": {
            "email": "dogood@gmail.com",
            "api_key": "913cdfa4c724c60ef5d3f77482d0697c"
        }
    }
}
</code>
</pre>
</details>

<details>
<summary>POST '/api/v0/road_trip' (Possible Route)</summary>

Request Body:
<pre>
<code>
{
    "origin": "Las Vegas, NV",
    "destination": "San Diego, CA",
    "api_key": "913cdfa4c724c60ef5d3f77482d0697c"
}
</code>
</pre>

Response:
<pre>
<code>
{
    "data": {
        "id": null,
        "type": "road_trip",
        "attributes": {
            "start_city": "Las Vegas, NV",
            "end_city": "San Diego, CA",
            "travel_time": "4h58m",
            "weather_at_eta": {
                "datetime": "2023-04-25 12:00",
                "temperature": 66.6,
                "condition": "Sunny"
            }
        }
    }
}
</code>
</pre>
</details>

<details>
<summary>POST 'api/v0/road_trip' - Impossible Route</summary>

Request Body:
<pre>
<code>
{
    "origin": "Las Vegas, NV",
    "destination": "Melbourne, AU",
    "api_key": "913cdfa4c724c60ef5d3f77482d0697c"
}
</code>
</pre>

Response:
<pre>
<code>
{
    "data": {
        "id": null,
        "type": "road_trip",
        "attributes": {
            "start_city": "Las Vegas, NV",
            "end_city": "Melbourne, AU",
            "travel_time": "impossible",
            "weather_at_eta": {}
        }
    }
}
</code>
</pre>
</details>


## APIs Used

[Mapquest Geocoding API](https://developer.mapquest.com/documentation/geocoding-api/) provided the latitude and longitude of a given location.

[Mapquest Directions API](https://developer.mapquest.com/documentation/directions-api/) was utilized to get the duration data for a road trip.

[Weather API](https://www.weatherapi.com/)
was employed to get information about the forecast, including current weather, the 5-day forecast, and hourly weather.


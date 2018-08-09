//
//  FiveDayWeatherForecast.swift
//  FiveDay
//
//  Created by Eddie Caballero on 7/25/18.
//  Copyright © 2018 Eddie Caballero. All rights reserved.
//

import Foundation

struct FiveDayWeatherForecast: Decodable
{
    let code: Int?
    let message: Double?
    var city: City?
    let cnt: Int?
    let list: [List?]?
}

struct City: Decodable
{
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}

struct Coord: Decodable
{
    let lat: Double?
    let lon: Double?
}

struct List: Decodable
{
    let dt: Int?
    let main: Main?
    let weather: [Weather?]?
    let clouds: Clouds?
    let wind: Wind?
    //let rain: Rain?
    //let snow: Snow?
    let sys: Sys?
    let dt_txt: String?
}

struct Main: Decodable
{
    let temp: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let sea_level: Double?
    let grnd_level: Double?
    let humidity: Int?
    let temp_kf: Double?
}

struct Weather: Decodable
{
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Clouds: Decodable
{
    let all: Int?
}

struct Wind: Decodable
{
    let speed: Double?
    let deg: Double?
}

/*
struct Rain: Decodable
{
    let _3h: Int?
}

struct Snow: Decodable
{
    let _3h: Int?
}
*/

struct Sys: Decodable
{
    let pod: String?
}

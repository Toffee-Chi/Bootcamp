package com.example.xmlcodebasic.superheroapp

import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Path


interface ApiService {

    @GET("19403a9087d0cef43435826616eea521/search/{name}")

    suspend fun getSuperheroes(@Path("name") superheroName: String):Response<SuperHeroDataResponse>

    @GET("/api/19403a9087d0cef43435826616eea521/{id}")
    suspend fun getSuperheroDetail(@Path("id") superheroID: String): Response<SuperHeroDetailResponse>
}
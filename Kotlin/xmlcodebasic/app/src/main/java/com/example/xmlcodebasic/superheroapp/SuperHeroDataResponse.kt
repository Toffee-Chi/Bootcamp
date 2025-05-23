package com.example.xmlcodebasic.superheroapp

import com.google.gson.annotations.SerializedName

data class SuperHeroDataResponse (
    @SerializedName("response") val response: String,
    @SerializedName("results") val superheroes: List<SuperheroItemResponse>
    )

data class SuperheroItemResponse(
    @SerializedName("id") val superheroID: String,
    @SerializedName("name") val name: String,
    @SerializedName("image") val superheroImage: SuperheroImageResponse

)

data class SuperheroImageResponse(@SerializedName("url") val url: String)
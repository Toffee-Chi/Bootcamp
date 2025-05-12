package com.example.mapcompose

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import com.example.mapcompose.ui.theme.MapComposeTheme
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.GoogleMap
import com.google.maps.android.compose.MapProperties
import com.google.maps.android.compose.MapType
import com.google.maps.android.compose.MapUiSettings
import com.google.maps.android.compose.Marker
import com.google.maps.android.compose.rememberMarkerState

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MapComposeTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MyGoogleMaps()
                }
            }
        }
    }
}

@Composable
fun MyGoogleMaps() {
    val markerState1 = rememberMarkerState(position = LatLng(28.270833, -16.63916))
    val markerState2 = rememberMarkerState(position = LatLng(20.270833, -26.63916))
    val properties by remember { mutableStateOf(MapProperties(mapType = MapType.HYBRID)) }
    val uiSetting by remember { mutableStateOf(MapUiSettings(zoomControlsEnabled = false)) }


    GoogleMap(
        modifier = Modifier.fillMaxSize(),
        properties = properties,
        uiSettings = uiSetting
    ) {
        Marker(
            state = markerState1,
            title = "Volcán?",
            snippet = "¿Seguro que vives aquí?"
        )
        Marker(
            state = markerState2,
            title = "Otro volcán?",
            snippet = "Ubicación random"
        )
    }
}

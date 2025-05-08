package com.example.columnapplication

import android.os.Bundle
import android.widget.Toast
import androidx.compose.ui.Alignment
import androidx.compose.ui.graphics.Color
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.FabPosition
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.traceEventEnd
import androidx.compose.ui.platform.LocalContext

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {

            ViewContainer()
        }
    }
}

@Preview
@Composable
fun ViewContainer() {
    Scaffold(
        topBar = { Toolbar() },
        floatingActionButton = { FAB() },
        floatingActionButtonPosition = FabPosition.End
    ) { innerPadding ->
        Content(modifier = Modifier.padding(innerPadding))
    }
}


@Composable
fun FAB() {
    val context = LocalContext.current
    FloatingActionButton(onClick = {
        Toast.makeText(context, "Botoncito", Toast.LENGTH_SHORT).show()
    }){
        Text(text = "X")
    }
}

@OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)
@Composable
fun Toolbar() {
    TopAppBar(
        title = { Text(text = "Profile Example:") },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = Color(0xFFFFA500)
        )
    )
}


@Composable
fun Content(modifier: Modifier = Modifier) {
    var counter by rememberSaveable { mutableStateOf(0) }

    LazyColumn(
        modifier = modifier
            .fillMaxSize()
            .background(Color(0xFFFFD580))
            .padding(16.dp)
    ) {
        item {
            Column(modifier = Modifier.fillMaxWidth()) {
                Image(
                    painter = painterResource(id = R.drawable.ic_orange_kawai),
                    contentDescription = "orange",
                    modifier = Modifier.align(Alignment.CenterHorizontally)
                )
            }
            Text(
                text = "Columna Principal",
                fontSize = 32.sp,
                color = Color.White,
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Center
            )
            Text(
                text = "Columna 1"
            )

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(25.dp)
            ) {
                Text(text = "Cantidad de cariño a la naranja: ", color = Color.White)
                Text(
                    text = counter.toString(),
                    color = Color.White,
                    modifier = Modifier.padding(start = 43.dp)
                )
                Image(
                    modifier = Modifier.clickable { counter++ },
                    painter = painterResource(id = R.drawable.ic_like),
                    contentDescription = "like"
                )

            }
            LazyRow(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                item {
                    Text(text = "Fila 1", color = Color.White)
                    Text(text = "Fila 2", color = Color.Red)
                    Text(text = "Fila 3", color = Color.Blue)
                    Text(text = "Fila 4", color = Color.White)
                    Text(text = "Fila 5", color = Color.Red)
                    Text(text = "Fila 6", color = Color.Blue)
                    Text(text = "Fila 7", color = Color.White)
                    Text(text = "Fila 8", color = Color.Red)
                    Text(text = "Fila 9", color = Color.Blue)
                    Text(text = "Fila 10", color = Color.White)

                }

            }
        }
    }
}
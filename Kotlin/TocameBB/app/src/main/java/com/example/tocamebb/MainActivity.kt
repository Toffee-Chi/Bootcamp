package com.example.tocamebb

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {

        splashQuick()

        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)

        val btnMenuStart = findViewById<Button>(R.id.btnMenuStart)
        btnMenuStart.setOnClickListener { navigateToRandomBtnApp() }

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun splashQuick() {

        setTheme(R.style.Theme_TocameBB)
    }

    private fun navigateToRandomBtnApp() {

        val intent = Intent(this, RandomBtnActivity::class.java)
        startActivity(intent)

    }
}

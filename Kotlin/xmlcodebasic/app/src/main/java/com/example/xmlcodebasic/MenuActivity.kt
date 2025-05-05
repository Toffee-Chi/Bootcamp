package com.example.xmlcodebasic

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.xmlcodebasic.firstapp.FirstAppActivity
import com.example.xmlcodebasic.imccalculator.ImcCalculatorActivity
import com.example.xmlcodebasic.settings.SettingActivity
import com.example.xmlcodebasic.superheroapp.SuperHeroListActivity
import com.example.xmlcodebasic.todoapp.TodoActivity
import okhttp3.internal.http2.Settings

class MenuActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_menu)
        val btnSaludApp = findViewById<Button>(R.id.btnSaludApp)
        val btnImcApp = findViewById<Button>(R.id.btnIMCAPP)
        val btnTODO = findViewById<Button>(R.id.btnTODO)
        val btnSuperhero = findViewById<Button>(R.id.btnSuperhero)
        val btnSettings = findViewById<Button>(R.id.btnSettings)


        btnSaludApp.setOnClickListener { navigateToSaludApp() }
        btnImcApp.setOnClickListener { navigateToImcApp() }
        btnTODO.setOnClickListener { navigateToTodoApp() }
        btnSuperhero.setOnClickListener { navigateToSuperheroApp() }
        btnSettings.setOnClickListener { navigateToSettings() }


        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }
    private fun navigateToTodoApp(){
        val intent= Intent(this, TodoActivity::class.java)
        startActivity(intent)

    }
    private fun navigateToImcApp(){
        val intent= Intent(this, ImcCalculatorActivity::class.java)
        startActivity(intent)

    }
   private fun navigateToSaludApp(){
        val intent= Intent(this, FirstAppActivity::class.java)
        startActivity(intent)
    }
    private fun navigateToSuperheroApp(){
        val intent= Intent(this, SuperHeroListActivity::class.java)
        startActivity(intent)
    }
    private fun navigateToSettings(){
        val intent= Intent(this, SettingActivity::class.java)
        startActivity(intent)
    }
}
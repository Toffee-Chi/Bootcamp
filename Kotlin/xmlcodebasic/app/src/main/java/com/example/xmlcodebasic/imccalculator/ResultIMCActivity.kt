package com.example.xmlcodebasic.imccalculator

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.example.xmlcodebasic.R
import com.example.xmlcodebasic.imccalculator.ImcCalculatorActivity.Companion.IMC_KEY

class ResultIMCActivity : AppCompatActivity() {

    private lateinit var tvResult: TextView
    private lateinit var tvIMC: TextView
    private lateinit var tvDescription: TextView
    private lateinit var btnReCalculate: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_result_imcactivity)
        val result = intent.extras?.getDouble(IMC_KEY) ?: -1.0
        initComponents()
        initUI(result)
        initListener()
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
    }

    private fun initListener() {
        btnReCalculate.setOnClickListener { onBackPressedDispatcher.onBackPressed() }
    }

    private fun initUI(result: Double) {
        tvIMC.text = result.toString()
        when (result) {
            in 0.00..18.50 -> { //peso bajo
                tvResult.text = getString(R.string.tittle_bajo_peso)
                tvResult.setTextColor(ContextCompat.getColor(this, R.color.peso_bajo))
                tvDescription.text = getString(R.string.description_bajo_peso)
            }

            in 18.51..24.99 -> { //peso normal
                tvResult.text = getString(R.string.tittle_normal_peso)
                tvResult.setTextColor(ContextCompat.getColor(this, R.color.peso_normal))

                tvDescription.text = getString(R.string.description_normal_peso)
            }

            in 25.00..29.99 -> { //peso elevado
                tvResult.text = getString(R.string.tittle_sobrepeso_peso)
                tvResult.setTextColor(ContextCompat.getColor(this, R.color.peso_sobrepeso))

                tvDescription.text = getString(R.string.description_obesidad_peso)
            }

            in 30.00..39.00 -> { //peso recontramorbido
                tvResult.text = getString(R.string.tittle_obesidad_peso)
                tvResult.setTextColor(ContextCompat.getColor(this, R.color.peso_obesidad))

                tvDescription.text = getString(R.string.description_sobrepeso_peso)
            }

            else -> { // que sos?
                tvResult.text = getString(R.string.Error)
                tvResult.setTextColor(ContextCompat.getColor(this, R.color.peso_obesidad))

                tvDescription.text = getString(R.string.Error)
                tvIMC.text = getString(R.string.Error)
            }
        }
    }

    private fun initComponents() {
        tvResult = findViewById(R.id.tvResult)
        tvIMC = findViewById(R.id.tvIMC)
        tvDescription = findViewById(R.id.tvDescription)
        btnReCalculate = findViewById(R.id.btnReCalculate)
    }
}
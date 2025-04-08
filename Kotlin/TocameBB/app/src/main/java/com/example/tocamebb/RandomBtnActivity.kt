package com.example.tocamebb

import android.animation.ObjectAnimator
import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.View
import android.widget.ImageButton
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import android.widget.Button
import android.os.Looper
import android.os.Handler
import android.os.CountDownTimer
import android.widget.TextView
import kotlin.random.Random

class RandomBtnActivity : AppCompatActivity() {

    private lateinit var btnPlay: Button
    private lateinit var btnFruitCool: ImageButton
    private lateinit var fakeButtons: List<ImageButton>
    private lateinit var tvToolbarTextView: TextView
    private lateinit var tvToolbarTime: TextView

    private var isGameRunning = false
    private val handler = Handler(Looper.getMainLooper())
    private var countdownTimer: CountDownTimer? = null
    private var scoreTop: Int = 0
    private var finalScore: Int = 0 // Para almacenar el puntaje final antes de resetearlo

    override fun onCreate(savedInstanceState: Bundle?) {
        window.statusBarColor = ContextCompat.getColor(this, R.color.btnMenuTint)
        super.onCreate(savedInstanceState)
        initComponent()
        initToolBar()
        initListener()
        btnFruitCool.isEnabled = false
        initButtonFake()

    }

    private fun initComponent() {
        setContentView(R.layout.activity_random_btn)
        btnPlay = findViewById(R.id.btnPlay)
        tvToolbarTextView = findViewById(R.id.tvToolbarText)
        tvToolbarTime = findViewById(R.id.tvToolbarTime)
        btnFruitCool = findViewById(R.id.btnfruitcool)
        fakeButtons = listOf(
            findViewById(R.id.btnfake1),
            findViewById(R.id.btnfake2),
            findViewById(R.id.btnfake3)
        )
        btnPlay.setOnClickListener {
            if (!isGameRunning) {
                startGame()
                startTimer()
            }
        }
    }

    private fun initToolBar() {
        val toolbar: Toolbar = findViewById(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.title = "Catch the Cool!"
    }

    private fun initButtonFake() {
        fakeButtons.forEach { it.visibility = View.GONE }
    }

    private fun startGame() {
        isGameRunning = true

        // Habilitar el btnFruitCool cuando empieza el juego
        btnFruitCool.isEnabled = true

        fakeButtons.forEach { button ->
            button.visibility = View.VISIBLE
            animateButtonRandomly(button)
        }

        val gameDuration = 30000L
        val moveInterval = 500L
        val stopTime = System.currentTimeMillis() + gameDuration

        handler.postDelayed(object : Runnable {
            override fun run() {
                fakeButtons.forEach { animateButtonRandomly(it) }
                animateButtonRandomly(btnFruitCool)
                if (System.currentTimeMillis() < stopTime) {
                    handler.postDelayed(this, moveInterval)
                }
            }
        }, 0)

        handler.postDelayed({
            fakeButtons.forEach { it.visibility = View.GONE }
            resetFruitCoolPosition()
            isGameRunning = false
        }, gameDuration)
    }

    private fun animateButtonRandomly(button: ImageButton) {
        val randomX = Random.nextInt(-150, 443).toFloat()
        val randomY = Random.nextInt(-150, 670).toFloat()

        ObjectAnimator.ofFloat(button, "translationX", randomX).apply {
            duration = 500
            start()
        }
        ObjectAnimator.ofFloat(button, "translationY", randomY).apply {
            duration = 500
            start()
        }
    }

    private fun initListener() {
        btnFruitCool.setOnClickListener {
            scoreTop += 1
            setScore()
        }
        fakeButtons.forEach { button ->
            button.setOnClickListener {
                scoreTop -= 1
                setScore()
            }
        }
    }

    private fun resetFruitCoolPosition() {
        btnFruitCool.animate()
            .translationX(0f)
            .translationY(0f)
            .setDuration(500)
            .start()
    }

    private fun setScore() {
        val score = scoreTop.toString()
        tvToolbarTextView.text = "Score: $score"
    }

    private fun startTimer() {
        countdownTimer?.cancel()
        countdownTimer = object : CountDownTimer(30000, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                val time = (millisUntilFinished / 1000).toString()
                tvToolbarTime.text = "Time: $time"
            }

            override fun onFinish() {
                tvToolbarTime.text = "Time: 0"

                // Guardar el puntaje final antes de resetearlo
                finalScore = scoreTop

                // Reiniciar el puntaje a 0
                scoreTop = 0
                setScore()

                // Reiniciar el tiempo a 30 segundos
                tvToolbarTime.text = "Time: 30"

                // Deshabilitar el btnFruitCool al terminar el tiempo
                btnFruitCool.isEnabled = false

                // Mostrar el diálogo al finalizar el tiempo
                showDialog()
            }
        }
        countdownTimer?.start()
    }
    private fun saveHighScore(score: Int) {
        val sharedPref = getSharedPreferences("GamePrefs", Context.MODE_PRIVATE)
        val editor = sharedPref.edit()
        editor.putInt("HIGH_SCORE", score) // Guardamos el puntaje
        editor.apply() // Confirmamos los cambios
    }
    private fun getHighScore(): Int {
        val sharedPref = getSharedPreferences("GamePrefs", Context.MODE_PRIVATE)
        return sharedPref.getInt("HIGH_SCORE", 0) // Si no hay puntaje guardado, devuelve 0
    }

    private fun showDialog() {
        val dialog = Dialog(this)
        dialog.setContentView(R.layout.dialog_end)

        dialog.setCancelable(false)

        val tvYouScore: TextView = dialog.findViewById(R.id.tvYouScore)
        val tvHighScore: TextView = dialog.findViewById(R.id.top)
        val btnDialogBack: Button = dialog.findViewById(R.id.btnDialogBack)

        // Obtener el puntaje más alto guardado
        val highScore = getHighScore()

        // Comparar y guardar si el puntaje actual es mayor
        if (finalScore > highScore) {
            saveHighScore(finalScore) // Guardamos el nuevo puntaje más alto
        }

        // Mostrar los puntajes en el diálogo
        tvYouScore.text = "Your Score: $finalScore"
        tvHighScore.text = "High Score: ${getHighScore()}"

        btnDialogBack.setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()
    }

}



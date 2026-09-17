package com.recova.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.recova.app.ui.navigation.RecovaApp
import com.recova.app.ui.theme.RecovaTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            RecovaTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = RecovaTheme.colors.canvasBase
                ) {
                    RecovaApp()
                }
            }
        }
    }
}

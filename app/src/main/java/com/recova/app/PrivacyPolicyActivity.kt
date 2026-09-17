package com.recova.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.sp
import com.recova.app.ui.theme.RecovaTheme

class PrivacyPolicyActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            RecovaTheme {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.padding(horizontal = androidx.compose.ui.unit.dp.times(32))
                    ) {
                        Text(
                            text = "Recova Privacy Policy",
                            color = Color.White,
                            fontSize = 24.sp
                        )
                        Spacer(modifier = Modifier.height(androidx.compose.ui.unit.dp.times(16)))
                        Text(
                            text = "Recova stores all your health data locally on your device. " +
                                    "No data is sent to any external server. " +
                                    "Your biometric information never leaves your phone.",
                            color = Color.White.copy(alpha = 0.7f),
                            fontSize = 14.sp
                        )
                    }
                }
            }
        }
    }
}

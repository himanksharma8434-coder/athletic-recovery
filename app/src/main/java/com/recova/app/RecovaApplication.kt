package com.recova.app

import android.app.Application

class RecovaApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Database and WorkManager initialization will be added in later phases
    }
}

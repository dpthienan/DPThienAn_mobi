package com.example.uthtodo.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.uthtodo.ui.screens.OnboardingScreen
import com.example.uthtodo.ui.screens.SplashScreen

@Composable
fun AppNavigation(navController: NavHostController = rememberNavController()) {
    NavHost(
        navController = navController,
        startDestination = Routes.SPLASH
    ) {
        composable(Routes.SPLASH) {
            SplashScreen(
                onFinished = {
                    navController.navigate(Routes.ONBOARDING) {
                        popUpTo(Routes.SPLASH) { inclusive = true }
                    }
                }
            )
        }
        composable(Routes.ONBOARDING) {
            OnboardingScreen(
                onSkip = {
                    // Bỏ qua — kết thúc onboarding, không điều hướng thêm
                },
                onFinished = {
                    // Bắt đầu ngay — kết thúc onboarding, không điều hướng thêm
                }
            )
        }
    }
}

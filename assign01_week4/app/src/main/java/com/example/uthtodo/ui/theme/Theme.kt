package com.example.uthtodo.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightColors = lightColorScheme(
    primary = PurplePrimary,
    onPrimary = White,
    secondary = PurpleDark,
    background = White,
    surface = White,
    onBackground = TextPrimary,
    onSurface = TextPrimary
)

@Composable
fun UTHTodoTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = LightColors,
        typography = Typography,
        content = content
    )
}

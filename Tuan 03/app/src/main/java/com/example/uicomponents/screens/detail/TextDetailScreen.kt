package com.example.uicomponents.screens.detail

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TextDetailScreen(onBack: () -> Unit) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Text Detail",
                        color = Color(0xFF2196F3),
                        fontWeight = FontWeight.Bold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = Color(0xFF2196F3)
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color.White
                )
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 32.dp, vertical = 48.dp)
        ) {
            // "The quick Brown fox jumps over the lazy dog."
            // Theo design: "quick" gạch ngang, "Brown" màu cam to, "fox j u m p s" letter spacing
            // "over" in nghiêng đậm, "the" gạch dưới, "lazy" in nghiêng, "dog." bình thường
            Text(
                text = buildAnnotatedString {
                    // "The "
                    withStyle(SpanStyle(fontSize = 32.sp, color = Color.Black)) {
                        append("The ")
                    }
                    // "quick" - strikethrough
                    withStyle(
                        SpanStyle(
                            fontSize = 32.sp,
                            color = Color.Black,
                            textDecoration = TextDecoration.LineThrough
                        )
                    ) {
                        append("quick")
                    }
                    append(" ")
                    // "Brown" - màu cam, font size lớn hơn
                    withStyle(
                        SpanStyle(
                            fontSize = 42.sp,
                            color = Color(0xFFFF8C00),
                            fontWeight = FontWeight.Bold
                        )
                    ) {
                        append("Brown")
                    }
                    append("\n")
                    // "fox j u m p s" - letter spacing
                    withStyle(
                        SpanStyle(
                            fontSize = 32.sp,
                            color = Color.Black,
                            letterSpacing = 6.sp
                        )
                    ) {
                        append("fox jumps")
                    }
                    append(" ")
                    // "over" - bold italic
                    withStyle(
                        SpanStyle(
                            fontSize = 32.sp,
                            color = Color.Black,
                            fontWeight = FontWeight.Bold,
                            fontStyle = FontStyle.Italic
                        )
                    ) {
                        append("over")
                    }
                    append("\n")
                    // "the" - underline
                    withStyle(
                        SpanStyle(
                            fontSize = 32.sp,
                            color = Color.Black,
                            textDecoration = TextDecoration.Underline
                        )
                    ) {
                        append("the")
                    }
                    append(" ")
                    // "lazy" - italic
                    withStyle(
                        SpanStyle(
                            fontSize = 32.sp,
                            color = Color.Black,
                            fontStyle = FontStyle.Italic
                        )
                    ) {
                        append("lazy")
                    }
                    // " dog."
                    withStyle(SpanStyle(fontSize = 32.sp, color = Color.Black)) {
                        append(" dog.")
                    }
                },
                lineHeight = 48.sp
            )
        }
    }
}

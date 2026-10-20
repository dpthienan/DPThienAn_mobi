package com.example.uicomponents.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.uicomponents.screens.ComponentListScreen
import com.example.uicomponents.screens.WelcomeScreen
import com.example.uicomponents.screens.detail.*

// Định nghĩa tất cả route trong app
object Routes {
    const val WELCOME = "welcome"
    const val COMPONENT_LIST = "component_list"

    // Display
    const val TEXT_DETAIL = "text_detail"
    const val IMAGE_DETAIL = "image_detail"

    // Input
    const val TEXTFIELD_DETAIL = "textfield_detail"
    const val PASSWORD_DETAIL = "password_detail"
    const val TOGGLE_DETAIL = "toggle_detail"
    const val SLIDER_DETAIL = "slider_detail"
    const val DATEPICKER_DETAIL = "datepicker_detail"

    // Layout
    const val ROW_DETAIL = "row_detail"
    const val COLUMN_DETAIL = "column_detail"

    // Selection
    const val BUTTON_DETAIL = "button_detail"
    const val CHECKBOX_DETAIL = "checkbox_detail"
    const val RADIOBUTTON_DETAIL = "radiobutton_detail"
    const val PICKER_DETAIL = "picker_detail"

    // Navigation
    const val NAVIGATIONVIEW_DETAIL = "navigationview_detail"
    const val TABBAR_DETAIL = "tabbar_detail"
    const val MENU_DETAIL = "menu_detail"

    // Content
    const val LIST_DETAIL = "list_detail"
    const val CARD_DETAIL = "card_detail"
    const val DIVIDER_DETAIL = "divider_detail"
}

@Composable
fun AppNavigation(navController: NavHostController = rememberNavController()) {
    NavHost(
        navController = navController,
        startDestination = Routes.WELCOME
    ) {
        composable(Routes.WELCOME) {
            WelcomeScreen(onReady = { navController.navigate(Routes.COMPONENT_LIST) })
        }
        composable(Routes.COMPONENT_LIST) {
            ComponentListScreen(
                onComponentClick = { route -> navController.navigate(route) }
            )
        }

        // Display
        composable(Routes.TEXT_DETAIL) {
            TextDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.IMAGE_DETAIL) {
            ImageDetailScreen(onBack = { navController.popBackStack() })
        }

        // Input
        composable(Routes.TEXTFIELD_DETAIL) {
            TextFieldDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.PASSWORD_DETAIL) {
            PasswordFieldDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.TOGGLE_DETAIL) {
            ToggleDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.SLIDER_DETAIL) {
            SliderDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.DATEPICKER_DETAIL) {
            DatePickerDetailScreen(onBack = { navController.popBackStack() })
        }

        // Layout
        composable(Routes.ROW_DETAIL) {
            RowDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.COLUMN_DETAIL) {
            ColumnDetailScreen(onBack = { navController.popBackStack() })
        }

        // Selection
        composable(Routes.BUTTON_DETAIL) {
            ButtonDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.CHECKBOX_DETAIL) {
            CheckboxDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.RADIOBUTTON_DETAIL) {
            RadioButtonDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.PICKER_DETAIL) {
            PickerDetailScreen(onBack = { navController.popBackStack() })
        }

        // Navigation
        composable(Routes.NAVIGATIONVIEW_DETAIL) {
            NavigationViewDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.TABBAR_DETAIL) {
            TabBarDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.MENU_DETAIL) {
            MenuDetailScreen(onBack = { navController.popBackStack() })
        }

        // Content
        composable(Routes.LIST_DETAIL) {
            ListDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.CARD_DETAIL) {
            CardDetailScreen(onBack = { navController.popBackStack() })
        }
        composable(Routes.DIVIDER_DETAIL) {
            DividerDetailScreen(onBack = { navController.popBackStack() })
        }
    }
}

# mengimport library
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(fmsb)
library(DT)


shiny::shinyOptions(sessionTimeLimit = 3600) 

hotel <- read.csv("data_hotel_clean.csv",
                  sep = ";")
names(hotel)

rf_model <- readRDS("rf_model.rds")

train_columns <- names(hotel)
dummy_columns <- setdiff(names(rf_model$forest$xlevels), names(hotel))
all_columns <- c(names(hotel), dummy_columns)

# membuat tanggal arrival
hotel$arrival_date <- as.Date(
  paste(hotel$arrival_year, hotel$arrival_month, hotel$arrival_date, sep = "-"),
  format = "%Y-%m-%d"
)


# membuat tampilan UI
ui <- dashboardPage(
  # membuat tampilan header
  dashboardHeader(
    title = tags$span(
      "Dashboard",
      style = "
      color: white; 
      font-size: 22px; 
      font-weight: 600;
      font-family: 'Poppins', sans-serif;
      display: block; width: 100%; text-align: center;"
      )
    ),
  
  
  # membuat tampilan sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      
      menuItem("About Dataset", icon = icon("info-circle"),
               menuSubItem("Dataset", tabName = "dataset", icon = icon("table")),
               menuSubItem("Variable Description", tabName = "variables", icon = icon("search"))
      ),
      
      menuItem("Data Analysis", icon = icon("chart-bar"),
               menuSubItem("Summary", tabName = "overview", icon = icon("folder")),
               menuSubItem("Visualizations", tabName = "visualizations", icon = icon("chart-line")),
               menuSubItem("Cancellation Prediction", 
                           tabName = "cancellation_predict", 
                           icon = icon("magic"))
      ),
      
      menuItem("More Information", tabName = "contact", icon = icon("phone"))
      )
    ),
  
  
  # membuat tampilan body dashboard
  dashboardBody(
    theme = bslib::bs_theme(version = 5),
    tags$head(
      tags$link(rel = "stylesheet",
                href = "https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap"),
      tags$style(HTML("
        /* Apply Poppins to all sidebar text */
        .main-sidebar, .sidebar-menu, .sidebar-menu a, .sidebar, 
        .sidebar .user-panel, .sidebar .sidebar-menu li a {
          font-family: 'Poppins', sans-serif !important;
        }

        .content-wrapper {
          background: linear-gradient(145deg, #0D1B2A, #1B263B, #415A77);
          padding-bottom: 30px;
        }

        /* Navbar */
        .main-header .navbar, .main-header .logo {
          background-color: #1B263B !important;
        }

        /* Sidebar */
        .main-sidebar {
          background-color: #0F1A2E !important;
        }
        .sidebar-menu > li > a {
          color: #E4E9F2 !important;
          font-size: 15px;
          transition: 0.25s;
        }
        .sidebar-menu > li > a:hover {
          background-color: #415A77 !important;
          color: #FFFFFF !important;
        }
        .sidebar-menu > li.active > a {
          background-color: #778DA9 !important;
          color: #0D1B2A !important;
          font-weight: 600;
        }

        /* Cards */
        .box {
          background-color: rgba(255,255,255,0.10) !important;
          border: 1px solid rgba(255,255,255,0.25) !important;
          border-radius: 12px !important;
          color: white !important;
        }

        h1, h2, h3, h4, h5, h6, p, label {
          color: #E4E9F2 !important;
        }
                      "))
      ),
    
    fluidRow(
      column(12,
             div(
               style = "padding: 12px; text-align: right;",
               tags$img(src = "https://www.its.ac.id/wp-content/uploads/2020/07/Logo-ITS-1-300x185.png",
                        height = "55px", style = "margin-right: 10px;"),
               tags$img(src = "https://www.its.ac.id/statistika/wp-content/uploads/sites/43/2018/03/logo-statistika-white-border.png",
                        height = "55px")
               )
             )
      ),
    
    
    # membuat tampilan tab
    tabItems(
      
      
      
      ## Home tab
      tabItem(
        tabName = "home",
        div(
          style = "
            padding: 30px; 
            background: rgba(255,255,255,0.15); 
            border-radius: 12px;
            backdrop-filter: blur(4px);
            margin: 25px;
          ",
          h2("Welcome!", style = "font-weight: 200;"),
          h1("Hotel Reservations Analysis Dashboard", style = "font-weight: 800;"),
          br(),
          p("This dashboard provides a comprehensive analysis of hotel booking patterns, 
            including cancellation behavior, customer types, and reservation trends across different segments. It enables company to explore how guests make reservations, 
            identify factors influencing cancellations, and uncover insights that can support better decision-making in hospitality management.",
            style = "font-size: 21px;"),
          br(),
          hr(style = "border-color: white;"),
          p("Learn more about the Hotel Booking Demand dataset",
            style = "font-size: 21px;"),
          tags$a(
            "Hotel Reservations Dataset (Kaggle)",
            href = "https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand",
            target = "_blank",
            style = "color: #FFD700; font-size: 24px; font-weight: bold; text-decoration: none;"
          )
        ),
        
        tags$style("
  .gallery-container {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
  }

  .image-box {
    position: relative;
    width: 30%;
    min-width: 300px;
    overflow: hidden;      /* ⬅ wajib supaya overlay penuh */
    border-radius: 12px;   /* ⬅ radius dipindah ke container */
  }

  .image-box img {
    width: 100%;
    height: 240px;
    object-fit: cover;
    transition: transform 0.4s;
  }

  /* Overlay memenuhi seluruh gambar */
  .overlay-text {
    position: absolute;
    inset: 0;
    background: rgba(0,0,0,0.55);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    font-weight: bold;
    opacity: 0;
    transition: 0.35s;
    border-radius: inherit; /* ⬅ mengikuti radius parent sempurna */
  }

  /* Hover baru muncul */
  .image-box:hover .overlay-text {
    opacity: 1;
  }

  /* Efek gambar sedikit zoom saat hover (premium look) */
  .image-box:hover img {
    transform: scale(1.07);
  }
"),
        
        
        div(
          style = "
    padding: 30px;
    background: rgba(255,255,255,0.15);
    border-radius: 12px;
    backdrop-filter: blur(4px);
    margin: 25px;
  ",
          
          tags$h1(
            "Does Reservation Cancellation Have a Significant Impact?",
            style = "text-align: center; font-weight: bold; color: white;"
          ),
          
          tags$p(
            "Something surprising was found behind hotel cancellation trends. You will want to know what it is.",
            style = "text-align: center; font-size: 21px; color: white; margin-bottom: 32px;"
          ),
          
          div(
            class = "gallery-container",
            
            # --- Gambar 1 ---
            div(
              class = "image-box",
              tags$a(
                href = "https://www.detik.com/jateng/bisnis/d-7776497/buntut-efisiensi-bookingan-hotel-banyak-cancel-hingga-karyawan-dirumahkan?",
                target = "_blank",
                tags$img(src = "https://akcdn.detik.net.id/community/media/visual/2024/12/13/ilustrasi-kamar-hotel_169.jpeg?w=700&q=90")
              ),
              tags$div(class = "overlay-text", "Tap & Explore Insights")
            ),
            
            # --- Gambar 2 ---
            div(
              class = "image-box",
              tags$a(
                href = "https://www.hotelmu.id/blog/read/234/strategi-mengurangi-tingkat-cancelation-booking-hotel.html?",
                target = "_blank",
                tags$img(src = "https://www.hotelmu.id/gambar/blog/blog-strategi-mengurangi-tingkat-cancelation-booking-hotel-234-l.png")
              ),
              tags$div(class = "overlay-text", "Tap & Explore Insights")
            ),
            
            # --- Gambar 3 ---
            div(
              class = "image-box",
              tags$a(
                href = "https://insights.ehotelier.com/insights/2025/04/16/how-cancellation-culture-is-impacting-hotel-revenue/?",
                target = "_blank",
                tags$img(src = "https://b508955.smushcdn.com/508955/wp-content/uploads/sites/6/2025/04/thumbnail_Hotel-pic-1.jpg?lossy=2&strip=1&webp=1")
              ),
              tags$div(class = "overlay-text", "Tap & Explore Insights")
            )
          )
        ),
        
        
        div(
          style = "
            padding: 30px; 
            background: rgba(255,255,255,0.15); 
            border-radius: 12px;
            backdrop-filter: blur(4px);
            margin: 25px;
          ",
          
          h1(
            "Understanding Hotel Reservation Data",
            style = "font-weight: 700; color: #2c3e50;"
          ),
          br(),
          p(
            "Hotel reservation data plays an important role in understanding guest behavior, 
            booking patterns, and demand trends in the hospitality industry. By analyzing reservation information such as booking dates, room types, 
            market segments, and cancellation status, hotels can gain valuable insights 
            to improve operational efficiency, pricing strategies, and guest satisfaction.",
            style = "font-size: 21px; color: #34495e; line-height: 1.6;"
          ),
          br(),
          hr(),
          p("More to read",
            style = "font-size: 21px;"),
          tags$a(
            "How Data Analytics Is Transforming the Hospitality Industry",
            href = "https://www.digitaljournal.com/pr/news/insights-news-wire/nupen-patel-data-analytics-improve-1195211362.html",
            target = "_blank",
            style = "color: #FFD700; font-size: 24px; font-weight: bold; text-decoration: none;"
          )
          
        ),
        
        
        div(
          style = "
    padding: 30px; 
    background: rgba(255,255,255,0.15); 
    border-radius: 12px;
    backdrop-filter: blur(4px);
    margin: 25px;
  ",
          
          h1(
            "Dashboard Menu Overview",
            style = "font-weight: 700; color: #2c3e50;"
          ),
          
          br(),
          
          p(
            HTML("🔍 <b>About Dataset</b> – Provides definitions of each variable in the dataset to support better understanding and analysis."),
            style = "font-size: 21px; color: #34495e; line-height: 1.6;"
          ),
          
          p(
            HTML("📊 <b>Reporting</b> – Presents various visualizations such as booking trends, cancellation rates, and the most preferred room types."),
            style = "font-size: 21px; color: #34495e; line-height: 1.6;"
          ),
          
          p(
            HTML("🧩 <b>Dataset Analysis</b> – Displays the results of hotel reservation analysis through multiple approaches, including segmentation and factors affecting cancellations."),
            style = "font-size: 21px; color: #34495e; line-height: 1.6;"
          ),
          
          p(
            HTML("📞 <b>More Information</b> – Provides the creator’s contact information for discussion, suggestions, or further collaboration."),
            style = "font-size: 21px; color: #34495e; line-height: 1.6;"
          )
          
          
        )
      ),
      
      ### Reporting
      tabItem(
        tabName = "overview",
        
        tags$style(HTML("
    .small-box .inner h3,
    .small-box .inner .kpi-value,
    .small-box h3,
    .small-box .value,
    .info-box-number {
      font-size: 46px !important;
      font-weight: 900 !important;
      line-height: 1.1;
    }
  ")),
        
        fluidRow(
          column(
            width = 4,
            box(
              title = "Reporting Perspective",
              width = 12,
              selectInput(
                "report_type",
                NULL,
                choices = c("Reservation", "Guest"),
                selected = "Reservation"
              )
            )
          ),
          column(
            width = 8,
            box(
              title = "Arrival Date Range",
              width = 12,
              dateRangeInput(
                inputId = "filter_date",
                label = NULL,
                start = min(hotel$arrival_date, na.rm = TRUE), 
                end   = max(hotel$arrival_date, na.rm = TRUE)
              )
            )
          )
        ),
        
        uiOutput("dynamic_kpi"),
        uiOutput("dynamic_visual")
      ),
      
      
      tabItem(
        tabName = "cancellation_predict",
        
        div(
          style = "
          padding: 30px; 
          margin: 25px;
          background: rgba(255,255,255,0.12);
          border-radius: 14px;
          backdrop-filter: blur(6px);",
          
          fluidPage(
            
            h1("Hotel Reservation Cancellation Prediction", style = "font-weight: 700; margin-bottom: 25px;"),
            
            p(
              "Use this form to predict whether a hotel booking is likely to be canceled or not.",
              style = "font-size: 18px; margin-bottom: 25px;"
            ),
            
            br(),
            
            fluidRow(
              column(
                width = 4,
                numericInput("adults", "Number of Adults", value = 0, min = 0),
                numericInput("children", "Number of Children", value = 0, min = 0),
                selectInput("meal", "Meal Type", choices = c("Not Selected","Meal Plan 1","Meal Plan 2","Meal Plan 3")),
                selectInput("parking", "Car Parking Space Required",
                            choices = c("No" = 0, "Yes" = 1))
              ),
              
              column(
                width = 4,
                selectInput("room", "Reserved Room Type",
                            choices = c("Room_Type 1", "Room_Type 2", "Room_Type 3", "Room_Type 4", "Room_Type 5", "Room_Type 6", "Room_Type 7")),
                numericInput("lead", "lead time", value = 100, min = 0),
                selectInput("market", "Market Segment Type",
                            choices = c("Offline","Online","Corporate")),
                numericInput("price", "Average Price per Room", value = 50, min = 0)
              ),
              
              column(
                width = 4,
                numericInput("previous_cancellations", "Previous Cancellations", value = 0, min = 0),
                numericInput("previous_bookings", "Previous Bookings Not Canceled", value = 0, min = 0),
                numericInput("total_nights", "Total Nights", value = 1, min = 1),
                numericInput("special_requests", "Special Requests", value = 0, min = 0),
                br(),
                actionButton("predict_cancellation", "Predict", class = "btn btn-primary")
              )
            ),
            
            hr(),
            uiOutput("styled_prediction_result")
          )
        ) 
      ),
      
      
      
      
      ## Contact tab
      tabItem(
        tabName = "contact",
        div(
          style = "
          padding: 35px; 
          margin: 25px;
          background: rgba(255,255,255,0.10);
          border-radius: 14px;
          backdrop-filter: blur(6px);",
          
          h1("Dashboard Goals", style = "font-weight: 600; margin-bottom: 20px;"),
          
          p(
            "This dashboard was developed as a Final Project for the Data Mining and Visualization course 
            in the Undergraduate Statistics Study Program, Department of Statistics, Faculty of Science 
            and Data Analytics, Institut Teknologi Sepuluh Nopember (ITS).",
            style = "font-size: 18px; margin-bottom: 25px;"
            ),
          
          hr(style = "border-color: #FFFFFF; margin-bottom: 35px;"),
          
          h1("About Us", style = "font-weight: 600; margin-bottom: 30px; text-align: center;"),
          
          tags$style(HTML("
          .profile-pic {
          border-radius: 50%;
          width: 150px;
          height: 150px;
          object-fit: cover;
          border: 3px solid #778DA9;
          box-shadow: 0px 0px 10px rgba(255,255,255,0.35);
          }
          .team-card {
          text-align: center;
          padding: 20px;
          }
          .team-name {
          font-size: 20px;
          font-weight: 600;
          margin-top: 12px;
          color: #E4E9F2;
          }
          .team-info {
          font-size: 16px;
          color: #ACB7C4;
          margin-bottom: 10px;
          }
          .social-icons-team a img {
          width: 32px;
          height: 32px;
          margin: 0 6px;
          transition: 0.25s;
          }
          .social-icons-team a img:hover {
          transform: scale(1.15);
          }
                          ")),
          
          fluidRow(
            column(3,
                   div(class = "team-card",
                       img(src = "https://media.licdn.com/dms/image/v2/D5603AQG1I2ytceQpPw/profile-displayphoto-shrink_400_400/B56ZViELgWGoAg-/0/1741107020093?e=1766620800&v=beta&t=qLwSYvWeTw6NGHEWR4hS797YxEc0TCDLBMVPpASIVIo", class = "profile-pic"),
                       p("Muhammad Aflah Ghozi S", class = "team-name"),
                       p("5003221074", class = "team-info"),
                       div(class = "social-icons-team",
                           tags$a(href="https://www.linkedin.com/in/aflah-ghozi-0b9605201/", target="_blank",
                                  img(src="https://cdn-icons-png.flaticon.com/512/3536/3536505.png")),
                           tags$a(href="mailto:ghoziaflah@gmail.com",
                                  img(src="https://cdn-icons-png.flaticon.com/512/732/732200.png"))
                       )
                   )
            ),
            column(3,
                   div(class = "team-card",
                       img(src = "https://media.licdn.com/dms/image/v2/D5603AQGvmKVjqyCpMg/profile-displayphoto-scale_400_400/B56ZqM3PYbJkAg-/0/1763299884138?e=1766620800&v=beta&t=hdYCRhF7Wa62Y0HAxBgWin45AX7KYWGOVuatgtDWB1w", class = "profile-pic"),
                       p("Rizal Afandi", class = "team-name"),
                       p("5003221116", class = "team-info"),
                       div(class = "social-icons-team",
                           tags$a(href="https://www.linkedin.com/in/rizalafandee/", target="_blank",
                                  img(src="https://cdn-icons-png.flaticon.com/512/3536/3536505.png")),
                           tags$a(href="mailto:rizalafandi1305@gmail.com",
                                  img(src="https://cdn-icons-png.flaticon.com/512/732/732200.png"))
                       )
                   )
            ),
            column(3,
                   div(class = "team-card",
                       img(src = "https://media.licdn.com/dms/image/v2/D5603AQF_cPEfWGH6mw/profile-displayphoto-scale_400_400/B56Zr5BHCoLwAk-/0/1765114411598?e=1766620800&v=beta&t=3dbAFvChmomcfwVe-_KJyQELyeNPE9VzlNbI1DO3RUw", class = "profile-pic"),
                       p("Ryanaldy Robby Kusuma", class = "team-name"),
                       p("5003221182", class = "team-info"),
                       div(class = "social-icons-team",
                           tags$a(href="https://www.linkedin.com/in/ryanaldi-robby-b103ab169/", target="_blank",
                                  img(src="https://cdn-icons-png.flaticon.com/512/3536/3536505.png")),
                           tags$a(href="mailto:aldirobby3799@gmail.com",
                                  img(src="https://cdn-icons-png.flaticon.com/512/732/732200.png"))
                       )
                   )
            ),
            column(3,
                   div(class = "team-card",
                       img(src = "https://media.licdn.com/dms/image/v2/D5603AQGc_KWH7G-VOA/profile-displayphoto-shrink_400_400/B56ZXrxGmeGUAg-/0/1743417274421?e=1766620800&v=beta&t=gAJdofYVD8CFsgoOk4YFbkj0hMpv6MaJIVdGXRvmaUo", class = "profile-pic"),
                       p("M Ilham Ramadhan", class = "team-name"),
                       p("5003221185", class = "team-info"),
                       div(class = "social-icons-team",
                           tags$a(href="https://www.linkedin.com/in/ilhamramadhanm", target="_blank",
                                  img(src="https://cdn-icons-png.flaticon.com/512/3536/3536505.png")),
                           tags$a(href="mailto:ilhammuhramadhan@gmail.com",
                                  img(src="https://cdn-icons-png.flaticon.com/512/732/732200.png"))
                           )
                       )
                   )
            )
          )
        ),
      
      
      
      ## Variable Description tab
      tabItem(
        tabName = "variables",
        div(
          style = "
          padding: 30px; 
          margin: 25px;
          background: rgba(255,255,255,0.10);
          border-radius: 14px;
          backdrop-filter: blur(6px);",
          
          h1("Dataset Metadata", style = "font-weight: 600; margin-bottom: 20px;"),
          
          p("Below is the description of every variable included in the hotel bookings dataset:",
            style = "font-size: 18px; margin-bottom: 25px;"),
          
          DT::dataTableOutput("metadata_table")
        )
      ),
      
      
      
      ## Dataset tab
      tabItem(
        tabName = "dataset",
        
        div(
          style = "
      padding: 30px; 
      margin: 25px;
      background: rgba(255,255,255,0.12);
      border-radius: 14px;
      backdrop-filter: blur(6px);",
          
          h1("Dataset Overview", style = "font-weight: 600; margin-bottom: 20px;"),
          
          p("You can download the dataset in CSV or Excel format using the buttons below.",
            style = "font-size: 18px; margin-bottom: 25px;"),
          
          div(
            style = "display: flex; gap: 15px; margin-bottom: 25px;",
            downloadButton("downloadCSV", "Download as CSV"),
            downloadButton("downloadExcel", "Download as Excel")
          ),
          
          h3("Hotel Reservation Dataset", style = "font-weight: 500; margin-bottom: 10px;"),
          
          DTOutput("dataset_table")
        )
      ),
      
      
      ## Visualization tab
      tabItem(
        tabName = "visualizations",
        div(
          style = "
      padding: 30px; 
      margin: 25px;
      background: rgba(255,255,255,0.12);
      border-radius: 14px;
      backdrop-filter: blur(6px);",
          
          h1("Hotel Reservations Report", style = "font-weight: 700; margin-bottom: 25px;"),
          
          p(
            "Explore the key metrics and trends in hotel reservations. Use the filters below to adjust the date range, booking status, and market segment to gain specific insights into customer behavior and booking patterns.",
            style = "font-size: 16px; margin-bottom: 25px;"
          ),
          
          div(
            style = "padding: 20px; border-radius: 12px; background: rgba(0,0,0,0.25); margin-bottom: 25px;",
            fluidRow(
              column(
                4,
                dateRangeInput(
                    inputId = "filter_date",
                    label = "Arrival Date Range",
                    start = min(hotel$arrival_date, na.rm = TRUE),
                    end   = max(hotel$arrival_date, na.rm = TRUE)
                  )
              ),
              column(
                4,
                selectInput("filter_status", "Booking Status",
                            choices = unique(hotel$booking_status),
                            selected = unique(hotel$booking_status),
                            multiple = TRUE)
              ),
              column(
                4,
                selectInput("filter_segment", "Market Segment",
                            choices = unique(hotel$market_segment_type),
                            selected = unique(hotel$market_segment_type),
                            multiple = TRUE)
              ),
            )
          ),
          
          tabsetPanel(
            tabPanel(
              "Yearly",
              br(),
              fluidRow(
                column(6, plotOutput("plot_yearly_1", height = "350px")),
                column(6, plotOutput("plot_yearly_2", height = "350px"))
              ),
              br(),
              fluidRow(
                column(6, plotOutput("plot_yearly_3", height = "350px")),
                column(6, plotOutput("plot_yearly_4", height = "350px"))
              )
            ),
            
            tabPanel(
              "Monthly",
              br(),
              fluidRow(
                column(6, plotOutput("plot_monthly_1", height = "350px")),
                column(6, plotOutput("plot_monthly_2", height = "350px"))
              ),
              br(),
              fluidRow(
                column(6, plotOutput("plot_monthly_3", height = "350px")),
                column(6, plotOutput("plot_monthly_4", height = "350px"))
              )
            )
          )
        )
      )
      # Tab lain
    )
  )
)





# Server
server <- function(input, output, session) {
  
  
  ## Metadata variable description
  output$metadata_table <- DT::renderDataTable({
    metadata <- data.frame(
      Variable = c(
        "Booking_ID", "no_of_adults", "no_of_children", "no_of_weekend_nights",
        "no_of_week_nights", "type_of_meal_plan", "required_car_parking_space",
        "room_type_reserved", "lead_time", "arrival_year", "arrival_month",
        "arrival_date", "market_segment_type", "repeated_guest",
        "no_of_previous_cancellations", "no_of_previous_bookings_not_canceled",
        "avg_price_per_room", "no_of_special_requests", "booking_status", "reservation_status_date"
      ),
      Description = c(
        "Unique identifier of each booking",
        "Number of adults",
        "Number of children",
        "Number of weekend nights (Saturday or Sunday) stayed or booked",
        "Number of week nights (Monday to Friday) stayed or booked",
        "Type of meal plan booked by the customer",
        "Does the customer require a parking space? (0 = No, 1 = Yes)",
        "Type of room reserved (ciphered by INN Hotels)",
        "Days between booking date and arrival date",
        "Year of arrival",
        "Month of arrival",
        "Date of arrival (day of the month)",
        "Market segment designation",
        "Is the customer a repeated guest? (0 = No, 1 = Yes)",
        "Number of previous cancellations by the customer",
        "Number of previous bookings not canceled",
        "Average price per day of reservation (EUR)",
        "Total number of special requests",
        "Indicates whether the booking was canceled or not",
        "Date on which the customer made the reservation"
      )
    )
    
    metadata <- metadata[-nrow(metadata), ]
    
    DT::datatable(
      metadata,
      rownames = FALSE,
      class = 'display cell-border', 
      options = list(
        pageLength = 10,
        searching = TRUE,
        lengthChange = TRUE,
        autoWidth = TRUE,
        
        initComplete = DT::JS(
          "function(settings, json) {",
          "$(this.api().table().container()).css({'color': '#FFFFFF'});", 
          
          "$(this.api().columns().header()).css({'background-color': '#212B3B', 'color': '#FFFFFF'});",
          
          "$('td').css({'color': '#FFFFFF'});",
          "$('.dataTables_wrapper').css({'color': '#FFFFFF'});",
          "$('.dataTables_length label').css({'color': '#FFFFFF'});",
          "$('.dataTables_filter label').css({'color': '#FFFFFF'});",
          
          "}"
        )
      )
    )
  })
  
  
  ## Tombol download
  output$downloadCSV <- downloadHandler(
    filename = function() {
      
      paste("Hotel Reservations Dataset_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(hotel, file, row.names = FALSE)
    }
  )
  
  
  ## Tombol download Excel
  output$downloadExcel <- downloadHandler(
    filename = function() {
      paste("Hotel Reservations Dataset_", Sys.Date(), ".xlsx", sep = "")
    },
    content = function(file) {
      write.xlsx(hotel, file)
    })
  
  
  ## Dataset table
  output$dataset_table <- DT::renderDT({
    
    DT::datatable(
      hotel,
      options = list(
        scrollX = TRUE,
        pageLength = 10,
        
        initComplete = DT::JS(
          "function(settings, json) {",
          "$(this.api().table().container()).css({'color': '#FFFFFF'});", 
          
          "$('.dataTables_wrapper').css({'color': '#FFFFFF'});",
          "$('.dataTables_length label').css({'color': '#FFFFFF'});",
          "$('.dataTables_filter label').css({'color': '#FFFFFF'});",
          
          "$(this.api().columns().header()).css({'background-color': '#212B3B', 'color': '#FFFFFF'});",
          
          "}"
        )
      )
    ) %>% 
      DT::formatStyle(
        columns = names(hotel),
        color = "white"
      )
  })
  
  
  ## Filter visualization
  filtered_data <- reactive({
    hotel %>%
      dplyr::filter(
        market_segment_type %in% input$filter_segment,
        booking_status %in% input$filter_status,
        arrival_date >= input$filter_date[1],
        arrival_date <= input$filter_date[2]
      )
  })
  
  
  
  output$dynamic_kpi <- renderUI({
    req(input$report_type)
    
    if (input$report_type == "Reservation") {
      tagList(
        fluidRow(
          infoBox("Total Bookings", textOutput("total_bookings"),
                  icon = icon("hotel"), color = "purple", fill = TRUE),
          
          infoBox("Estimated Revenue", textOutput("estimated_revenue"),
                  icon = icon("wallet"), color = "green", fill = TRUE),
          
          infoBox("Average Daily Rate (ADR)", textOutput("adr"),
                  icon = icon("coins"), color = "blue", fill = TRUE)
        ),
        
        fluidRow(
          infoBox("Canceled Bookings", textOutput("canceled_bookings"),
                  icon = icon("ban"), color = "red", fill = TRUE),
          
          infoBox("Cancellation Rate (%)", textOutput("cancel_rate"),
                  icon = icon("percent"), color = "orange", fill = TRUE),
          
          infoBox("Avg Length of Stay (LOS)", textOutput("avg_los"),
                  icon = icon("moon"), color = "light-blue", fill = TRUE)
        )
      )
      
    } else {
      
      tagList(
        fluidRow(
          infoBox("Total Guests", textOutput("kpi_total_guest"),
                  icon = icon("users"), color = "purple", fill = TRUE),
          
          infoBox("Total Adults", textOutput("kpi_total_adults"),
                  icon = icon("user"), color = "blue", fill = TRUE),
          
          infoBox("Total Children", textOutput("kpi_total_children"),
                  icon = icon("child"), color = "green", fill = TRUE)
        ),
        
        fluidRow(
          infoBox("Repeated Guest (%)", textOutput("kpi_repeat_rate"),
                  icon = icon("redo"), color = "orange", fill = TRUE),
          
          infoBox("Car Parking Required", textOutput("kpi_car_req"),
                  icon = icon("car"), color = "teal", fill = TRUE),
          
          infoBox("Total Special Requests", textOutput("kpi_special_req"),
                  icon = icon("bell"), color = "light-blue", fill = TRUE)
        )
      )
    }
  })
  
  
  
  output$total_bookings <- renderText({
    nrow(filtered_data())
  })
  
  
  
  output$estimated_revenue <- renderText({
    df <- filtered_data()
    revenue <- sum(
      df$avg_price_per_room * 
        (df$no_of_week_nights + df$no_of_weekend_nights),
      na.rm = TRUE
    )
    scales::comma(round(revenue))
  })
  
  
  
  output$adr <- renderText({
    round(mean(filtered_data()$avg_price_per_room, na.rm = TRUE), 2)
  })
  
  
  
  output$canceled_bookings <- renderText({
    sum(filtered_data()$booking_status == "Canceled", na.rm = TRUE)
  })
  
  
  
  output$cancel_rate <- renderText({
    df <- filtered_data()
    if (nrow(df) == 0) return(0)
    canceled <- sum(df$booking_status == "Canceled")
    round((canceled / nrow(df)) * 100, 2)
  })
  
  
  
  output$avg_los <- renderText({
    df <- filtered_data()
    los <- df$no_of_week_nights + df$no_of_weekend_nights
    round(mean(los, na.rm = TRUE), 2)
  })
  
  
  
  output$kpi_total_guest <- renderText({
    sum(filtered_data()$no_of_adults +
          filtered_data()$no_of_children,
        na.rm = TRUE)
  })
  
  
  
  output$kpi_total_adults <- renderText({
    sum(filtered_data()$no_of_adults, na.rm = TRUE)
  })
  
  
  
  output$kpi_total_children <- renderText({
    sum(filtered_data()$no_of_children,
        na.rm = TRUE)
  })
  
  
  
  output$kpi_repeat_rate <- renderText({
    df <- filtered_data()
    if(nrow(df) == 0) return("0")
    
    rate <- mean(df$repeated_guest, na.rm = TRUE) * 100
    paste0(round(rate, 2), " %")
  })
  
  
  
  output$kpi_car_req <- renderText({
    sum(filtered_data()$required_car_parking_space, na.rm = TRUE)
  })
  
  
  
  output$kpi_special_req <- renderText({
    sum(filtered_data()$no_of_special_requests, na.rm = TRUE)
  })
  
  
  
  output$dynamic_visual <- renderUI({
    req(input$report_type)
    
    if (input$report_type == "Reservation") {
      fluidRow(
        box(width = 6, title = "Booking Trend Over Time", solidHeader = TRUE,
            plotOutput("bookingTrend")),
        box(width = 6, title = "Booking Status Distribution", solidHeader = TRUE,
            plotOutput("statusPlot"))
      )
    } else {
      fluidRow(
        box(width = 6, title = "Room Type Distribution", solidHeader = TRUE,
            plotOutput("pie_room")),
        box(width = 6, title = "Meal Type Distribution", solidHeader = TRUE,
            plotOutput("pie_meal"))
      )
    }
  })
  
  
  light_theme <- function() {
    theme_minimal(base_size = 14) +
      theme(
        
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        
        panel.grid.major = element_line(color = "gray85", linewidth = 0.1),
        panel.grid.minor = element_blank(),
        
        plot.title = element_text(color = "#0D1B2A", face = "bold", size = 16, hjust = 0.5),
        axis.title = element_text(color = "#0D1B2A", face = "bold"),
        axis.text = element_text(color = "#333333"),
        
        legend.position = "top",
        legend.background = element_rect(fill = "white", color = NA),
        legend.text = element_text(color = "#333333"),
        legend.title = element_text(color = "#0D1B2A", face = "bold"),
        
        plot.margin = ggplot2::margin(t = 10, r = 10, b = 10, l = 10)
      )
  }
  
  
  
  output$plot_yearly_1 <- renderPlot({
    df <- filtered_data() %>%
      group_by(arrival_year) %>%
      summarise(total_bookings = n())
    
    ggplot(df, aes(x = factor(arrival_year), y = total_bookings)) +
      geom_bar(stat = "identity", fill = "#5C9EAD", width = 0.55) +
      labs(
        title = "Total Bookings",
        x = "Year",
        y = "Total"
      ) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.title.x = element_text(margin = ggplot2::margin(t = 15)),
        axis.title.y = element_text(margin = ggplot2::margin(r = 15))
      )
  })
  
  
  
  output$plot_yearly_2 <- renderPlot({
    df <- filtered_data() %>%
      filter(!is.na(lead_time)) %>%
      mutate(arrival_year = factor(arrival_year))
    
    ggplot(df, aes(x = lead_time, fill = arrival_year)) +
      geom_histogram(position = "identity", alpha = 0.6, bins = 40, color = "white") +
      scale_fill_manual(
        values = c("2017" = "#5C9EAD", "2018" = "#A9D6E5")
      ) +
      labs(
        title = "Lead Time Distribution",
        x = "Days",
        y = "Count",
        fill = "Year"
      ) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.title.x = element_text(margin = ggplot2::margin(t = 15)),
        axis.title.y = element_text(margin = ggplot2::margin(r = 15))
      )
  })
  
  
  output$plot_yearly_3 <- renderPlot({
    df <- filtered_data() %>%
      group_by(arrival_year) %>%
      summarise(
        total_adults = sum(no_of_adults, na.rm = TRUE),
        total_children = sum(no_of_children, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      tidyr::pivot_longer(
        cols = c(total_adults, total_children),
        names_to = "type",
        values_to = "count"
      ) %>%
      mutate(
        type = recode(type,
                      "total_adults" = "Adults",
                      "total_children" = "Children")
      )
    
    color_palette <- c("Adults" = "#5C9EAD", "Children" = "#A9D6E5")
    
    ggplot(df, aes(x = factor(arrival_year), y = count, fill = type)) +
      geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.6) +
      scale_fill_manual(values = color_palette) +
      labs(
        title = "Comparison of Total Adults and Children",
        x = "Year",
        y = "Total",
        fill = "Guest Type"
      ) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.title.x = element_text(margin = ggplot2::margin(t = 15)),
        axis.title.y = element_text(margin = ggplot2::margin(r = 15))
      )
  })
  
  
  
  output$plot_yearly_4 <- renderPlot({
    df <- filtered_data() %>%
      group_by(arrival_year) %>%
      summarise(
        canceled = sum(booking_status == "Canceled", na.rm = TRUE),
        not_canceled = sum(booking_status != "Canceled", na.rm = TRUE),
        .groups = "drop"
      ) %>%
      tidyr::pivot_longer(
        cols = c(canceled, not_canceled),
        names_to = "status",
        values_to = "count"
      ) %>%
      mutate(
        status = recode(status,
                        "canceled" = "Canceled",
                        "not_canceled" = "Not Canceled")
      )
    
    color_palette <- c("Canceled" = "#E5383B", "Not Canceled" = "#5C9EAD")
    
    ggplot(df, aes(x = factor(arrival_year), y = count, fill = status)) +
      geom_bar(stat = "identity", position = "fill", width = 0.6) +
      scale_y_continuous(labels = scales::percent_format()) +
      scale_fill_manual(values = color_palette) +
      labs(
        title = "Booking Cancellation Rate",
        x = "Year",
        y = "Proportion",
        fill = "Booking Status"
      ) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.title.x = element_text(margin = ggplot2::margin(t = 15)),
        axis.title.y = element_text(margin = ggplot2::margin(r = 15))
      )
  })
  
  
  
  output$plot_monthly_1 <- renderPlot({
    df <- filtered_data() %>%
      mutate(arrival_month = factor(month.name[arrival_month], levels = month.name)) %>%
      group_by(arrival_year, arrival_month) %>%
      summarise(total_bookings = n(), .groups = 'drop')
    
    color_palette <- c("2017" = "#5C9EAD", "2018" = "#A9D6E5")
    
    ggplot(df, aes(x = arrival_month, y = total_bookings, fill = factor(arrival_year))) +
      geom_bar(stat="identity", position = "stack", width = 0.7) +
      labs(
        title = "Total Bookings",
        x = "Month",
        y = "Total",
        fill = "Year"
      ) +
      scale_fill_manual(values = color_palette) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.title.x = element_text(margin = ggplot2::margin(t = 15)),
        axis.title.y = element_text(margin = ggplot2::margin(r = 15)),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
  
  
  
  output$plot_monthly_2 <- renderPlot({
    df <- filtered_data() %>%
      mutate(arrival_month = factor(month.name[arrival_month], levels = month.name)) %>%
      group_by(arrival_month) %>%
      summarise(mean_lead_time = mean(lead_time, na.rm = TRUE), .groups = "drop")
    
    ggplot(df, aes(x = arrival_month, y = mean_lead_time)) +
      geom_line(group = 1, linewidth = 1, color = "#5C9EAD") +
      geom_point(size = 3, color = "#A9D6E5") +
      labs(
        title = "Average Lead Time",
        x = "Month",
        y = "Days"
      ) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.title.x = element_text(margin = ggplot2::margin(t = 15)),
        axis.title.y = element_text(margin = ggplot2::margin(r = 15)),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
  
  
  
  output$plot_monthly_3 <- renderPlot({
    df <- filtered_data() %>%
      mutate(arrival_month = factor(month.name[arrival_month], levels = month.name)) %>%
      group_by(arrival_month) %>%
      summarise(
        total_adults = sum(no_of_adults, na.rm = TRUE),
        total_children = sum(no_of_children, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      tidyr::pivot_longer(
        cols = c(total_adults, total_children),
        names_to = "type",
        values_to = "count"
      ) %>%
      mutate(
        type = recode(type,
                      "total_adults" = "Adults",
                      "total_children" = "Children")
      )
    
    color_palette <- c("Adults" = "#5C9EAD", "Children" = "#A9D6E5")
    
    ggplot(df, aes(x = arrival_month, y = count, fill = type, group = type)) +
      geom_area(alpha = 0.8, position = "stack") +
      labs(
        title = "Comparison of Total Adults and Children",
        x = "Month",
        y = "Total",
        fill = "Guest Type"
      ) +
      scale_fill_manual(values = color_palette) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
  
  
  
  output$plot_monthly_4 <- renderPlot({
    df <- filtered_data() %>%
      mutate(arrival_month = factor(month.name[arrival_month], levels = month.name)) %>%
      group_by(arrival_month) %>%
      summarise(
        canceled = sum(booking_status == "Canceled", na.rm = TRUE),
        not_canceled = sum(booking_status != "Canceled", na.rm = TRUE),
        .groups = "drop"
      ) %>%
      tidyr::pivot_longer(
        cols = c(canceled, not_canceled),
        names_to = "status",
        values_to = "count"
      ) %>%
      mutate(
        status = recode(status,
                        "canceled" = "Canceled",
                        "not_canceled" = "Not Canceled")
      )
    
    color_palette <- c("Canceled" = "#E5383B", "Not Canceled" = "#5C9EAD")
    
    ggplot(df, aes(x = arrival_month, y = count, fill = status)) +
      geom_bar(stat = "identity", position = "fill", width = 0.7) +
      scale_y_continuous(labels = scales::percent_format()) +
      scale_fill_manual(values = color_palette) +
      labs(
        title = "Booking Cancellation Rate",
        x = "Month",
        y = "Proportion",
        fill = "Booking Status"
      ) +
      light_theme() +
      theme(
        panel.grid.major.x = element_blank(),
        plot.title = element_text(size = 18),
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
  
  
  output$bookingTrend <- renderPlot({
    df <- filtered_data() %>%
      group_by(arrival_date) %>%
      summarise(total = n(), .groups = "drop")
    
    if (nrow(df) < 2) {
      return(ggplot() + light_theme() + labs(title = "Data terlalu sedikit untuk Line Plot"))
    }
    
    ggplot(df, aes(arrival_date, total)) +
      geom_line(size = 1.2, color = "#5C9EAD") +
      light_theme() +
      labs(x = "Arrival Date", y = "Total Bookings")
  })
  
  
  
  output$statusPlot <- renderPlot({
    df <- filtered_data() %>%
      count(booking_status)
    
    ggplot(df, aes(x = "", y = n, fill = booking_status)) +
      geom_col(width = 1) +
      coord_polar("y", start = 0) +
      light_theme() +
      theme(
        axis.text.x = element_blank(),
        axis.title = element_blank(),
        panel.grid.major = element_blank()
      ) +
      labs(fill = "Booking Status")
  })
  
  
  
  output$pie_room <- renderPlot({
    df <- filtered_data() %>%
      filter(!is.na(room_type_reserved)) %>%
      count(room_type_reserved)
    
    req(nrow(df) > 0)
    
    room_colors <- c(
      "Room_Type 1" = "#A9D6E5", "Room_Type 4" = "#5C9EAD",
      "Room_Type 3" = "#E5383B",
      "Room_Type 6" = "#2D6A4F", "Room_Type 2" = "#1B4332", 
      "Room_Type 5" = "#74C69D", "Room_Type 7" = "#B7E4C7", 
      "Other" = "gray50"
    )
    
    ggplot(df, aes(x = "", y = n, fill = room_type_reserved)) +
      geom_col(width = 1) +
      coord_polar("y", start = 0) +
      scale_fill_manual(values = room_colors) +
      light_theme() +
      theme(
        axis.text.x = element_blank(),
        axis.title = element_blank(),
        panel.grid.major = element_blank()
      ) +
      labs(fill = "Room Type")
  })
  
  output$pie_meal <- renderPlot({
    df <- filtered_data() %>%
      filter(!is.na(type_of_meal_plan)) %>%
      count(type_of_meal_plan) %>%
      
      mutate(
        percentage = n / sum(n),
        ymax = cumsum(percentage),
        ymin = c(0, head(ymax, n=-1)),
        label_position = (ymax + ymin) / 2
      )
    
    req(nrow(df) > 0)
    
    meal_colors <- c(
      "Meal Plan 1" = "#A9D6E5", "Meal Plan 2" = "#5C9EAD", 
      "Meal Plan 3" = "#2D6A4F", "Not Selected" = "#1B4332"
    )
    
    ggplot(df, aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 3, fill = type_of_meal_plan)) +
      
      geom_rect() + 
      
      coord_polar("y", start = 0) +
      scale_fill_manual(values = meal_colors) +
      
      light_theme() +
      theme(
        axis.text.x = element_blank(),
        axis.text.y = element_blank(), 
        axis.title = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid = element_blank()
      ) +
      labs(fill = "Meal Type") +
      xlim(c(2, 4)) 
  })
  
  observeEvent(input$predict_cancellation, {
    
    newdata <- as.data.frame(matrix(0, nrow=1, ncol=length(all_columns)), check.names = FALSE)
    colnames(newdata) <- all_columns
    
    newdata$no_of_adults <- ifelse(is.na(input$adults), 0, input$adults)
    newdata$no_of_children <- ifelse(is.na(input$children), 0, input$children)
    newdata$lead_time <- ifelse(is.na(input$lead), 0, input$lead)
    newdata$avg_price_per_room <- ifelse(is.na(input$price), 0, input$price)
    newdata$no_of_previous_cancellations <- ifelse(is.na(input$previous_cancellations), 0, input$previous_cancellations)
    newdata$no_of_previous_bookings_not_canceled <- ifelse(is.na(input$previous_bookings), 0, input$previous_bookings)
    newdata$total_nights <- ifelse(is.na(input$total_nights), 1, input$total_nights)
    newdata$no_of_special_requests <- ifelse(is.na(input$special_requests), 0, input$special_requests)
    newdata$total_people <- newdata$no_of_adults + newdata$no_of_children
    
    meal_map <- c("Meal Plan 2"="type_of_meal_plan_Meal Plan 2",
                  "Meal Plan 3"="type_of_meal_plan_Meal Plan 3",
                  "Not Selected"="type_of_meal_plan_Not Selected")
    if(input$meal %in% names(meal_map)) newdata[[ meal_map[[input$meal]] ]] <- 1
    
    if(input$parking == 1) newdata$`required_car_parking_space_Yes` <- 1
    
    room_col <- paste0("room_type_reserved_", input$room)
    if(room_col %in% colnames(newdata)) newdata[[room_col]] <- 1
    
    market_map <- c("Corporate"="market_segment_type_Corporate",
                    "Offline"="market_segment_type_Offline",
                    "Online"="market_segment_type_Online")
    if(input$market %in% names(market_map)) newdata[[ market_map[[input$market]] ]] <- 1
    
    newdata[is.na(newdata)] <- 0
    
    pred <- predict(rf_model, newdata)
    
    output$prediction_result <- renderText({
      status <- ifelse(pred == 0, "Not Canceled", "Canceled")
      paste("Predicted booking status:", status)
    })
    
  })
  
  output$styled_prediction_result <- renderUI({
    prediction_status <- "Not Canceled" 
    light_text_color <- "#FFFFFF"
    
    if (prediction_status == "Canceled") {
      result_text <- "High Risk of CANCELLATION"
      color_code <- "#dc3545"
    } else {
      result_text <- "Low Risk of Cancellation"
      color_code <- "#28a745"
    }
    
    wellPanel(
      style = paste0("border: 4px solid; border-color: ", color_code, 
                     "; padding: 30px; text-align: center; background-color: transparent; border-radius: 8px;"),
      
      # Teks Judul dibuat putih/terang
      h3("Prediction Result:", style = paste0("font-weight: 300; margin-bottom: 15px; color: ", light_text_color, ";")),
        
        tags$p(
          result_text, 
          style = paste0("font-size: 40px; font-weight: 700; color: ", light_text_color, 
                         "; margin-top: 5px; margin-bottom: 0px;")
      ),
      
      p("This prediction is based on the trained Machine Learning model.", 
        style = paste0("margin-top: 20px; font-style: italic; color: ", light_text_color, ";"))
    )
  })
  
  
}


# run dashboard
shinyApp(ui, server)

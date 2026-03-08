import streamlit as st
import pandas as pd
import plotly.express as px
import streamlit.components.v1 as components
import numpy as np
import os
import joblib
# =============================
# BASE PATH (WAJIB)
# =============================
BASE_DIR = os.path.dirname(__file__)
DATASET_DIR = os.path.join(BASE_DIR, "dataset")
MODEL_DIR = os.path.join(BASE_DIR, "model")

# --- Konfigurasi Halaman ---
st.set_page_config(
    layout="wide", 
    page_title="Dashboard Penjualan Interaktif",
    initial_sidebar_state="expanded" 
)

# Inisialisasi Session State
if 'view_option' not in st.session_state:
    st.session_state['view_option'] = None 
if 'seg_view_option' not in st.session_state:
    st.session_state['seg_view_option'] = "Explanation"

# --- KODE WARNA ---
ACCENT_COLOR = "#8A2BE2"     # Ungu Vibrant
LIGHT_ACCENT_COLOR = "#B260FF" 
TEXT_COLOR = "#000000"       # Hitam Pekat
WHITE = "#FFFFFF"

# --- PALET WARNA (COLD VIBE) ---
COLD_PALETTE = ["#8A2BE2", "#2980B9", "#1ABC9C"]

# --- MAPPING STATE ---
US_STATE_TO_CODE = {
    'Alabama': 'AL', 'Alaska': 'AK', 'Arizona': 'AZ', 'Arkansas': 'AR', 'California': 'CA',
    'Colorado': 'CO', 'Connecticut': 'CO', 'Delaware': 'DE', 'Florida': 'FL', 'Georgia': 'GA',
    'Hawaii': 'HI', 'Idaho': 'ID', 'Illinois': 'IL', 'Indiana': 'IN', 'Iowa': 'IA',
    'Kansas': 'KS', 'Kentucky': 'KY', 'Louisiana': 'LA', 'Maine': 'ME', 'Maryland': 'MD',
    'Massachusetts': 'MA', 'Michigan': 'MI', 'Minnesota': 'MN', 'Mississippi': 'MS', 'Missouri': 'MO',
    'Montana': 'MT', 'Nebraska': 'NE', 'Nevada': 'NV', 'New Hampshire': 'NH', 'New Jersey': 'NJ',
    'New Mexico': 'NM', 'New York': 'NY', 'North Carolina': 'NC', 'North Dakota': 'ND', 'Ohio': 'OH',
    'Oklahoma': 'OK', 'Oregon': 'OR', 'Pennsylvania': 'PA', 'Rhode Island': 'RI', 'South Carolina': 'SC',
    'South Dakota': 'SD', 'Tennessee': 'TN', 'Texas': 'TX', 'Utah': 'UT', 'Vermont': 'VT',
    'Virginia': 'VA', 'Washington': 'WA', 'West Virginia': 'WV', 'Wisconsin': 'WI', 'Wyoming': 'WY',
    'District of Columbia': 'DC'
}

# --- CUSTOM CSS ---
custom_css = f"""
<style>
@import url('https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700&display=swap');

/* 1. GLOBAL */
.stApp, [data-testid="stAppViewContainer"] {{ background-color: {WHITE} !important; }}
[data-testid="stSidebar"] {{ background-color: {ACCENT_COLOR} !important; color: white; }}
[data-testid="stSidebar"] * {{ color: white !important; }}

h1, h2, h3, h4, p, li, a {{ 
    font-family: 'Source Sans Pro', sans-serif !important; 
    color: {TEXT_COLOR} !important; 
}}

/* HEADER FIX */
[data-testid="stHeader"] {{
    background-color: rgba(0,0,0,0) !important;
    z-index: 999999;
}}
[data-testid="stHeader"] button[title="View fullscreen"] {{ visibility: hidden; }}
[data-testid="stHeader"] button {{ color: {TEXT_COLOR} !important; }}
[data-testid="stDecoration"] {{ visibility: hidden; }}

/* 2. CARD STYLE UNTUK CHART (BACK TO WHITE CARD + SHADOW) */
[data-testid="stPlotlyChart"] {{
    background-color: {WHITE};
    border-radius: 12px;
    box-shadow: 0px 6px 20px rgba(0, 0, 0, 0.15); /* Re-add shadow for card effect */
    padding: 0px; 
    border: 1px solid #e0e0e0; 
    overflow: hidden; 
}}

/* 3. LAYOUT & SPACING */
iframe[title="st.components.v1.html"] {{ width: 100% !important; border: none; }}
[data-testid="stVerticalBlock"] {{ gap: 0.5rem !important; }}
h3 {{ margin-top: 5px !important; margin-bottom: 10px !important; padding-top: 0px !important; }}
[data-testid="stHorizontalBlock"] {{ margin-bottom: -10px !important; }}

/* 4. TOMBOL */
.stButton > button {{
    background-color: {WHITE} !important; 
    color: {TEXT_COLOR} !important; 
    border: 1px solid #e0e0e0 !important; 
    border-radius: 8px !important; 
    box-shadow: none !important; 
    font-family: 'Source Sans Pro', sans-serif !important; 
    font-weight: 600 !important;
    padding: 0.5rem 1rem;
}}
.stButton > button:hover {{ 
    border: 1px solid {ACCENT_COLOR} !important; 
    color: {ACCENT_COLOR} !important;
    transform: translateY(-2px);
    transition: all 0.3s ease;
}}
[data-testid="stAppViewContainer"] > div:first-child {{ padding-top: 1rem !important; }}

/* 5. CUSTOM MULTISELECT & SELECTBOX */
.stMultiSelect span[data-baseweb="tag"] {{
    background-color: {ACCENT_COLOR} !important;
    border: 1px solid {ACCENT_COLOR} !important;
    border-radius: 8px !important; 
}}
.stMultiSelect span[data-baseweb="tag"] span {{
    color: #FFFFFF !important;
    -webkit-text-fill-color: #FFFFFF !important;
}}
div[data-baseweb="popover"] ul {{
    background-color: {ACCENT_COLOR} !important;
    border-radius: 8px !important;
}}
div[data-baseweb="popover"] li, 
div[data-baseweb="popover"] li span,
div[data-baseweb="popover"] li div {{
    color: #FFFFFF !important; 
}}
div[data-baseweb="popover"] li[aria-selected="true"] {{
    background-color: {LIGHT_ACCENT_COLOR} !important;
    color: #FFFFFF !important;
}}
.stMultiSelect > div > div > div {{
    border-color: #f0f0f0 !important;
    border-radius: 8px !important;
}}

/* 7. CUSTOM SIDEBAR MENU */
[data-testid="stSidebar"] [data-testid="stRadio"] label > div:first-child {{
    display: none !important;
}}
[data-testid="stSidebar"] [data-testid="stRadio"] > div {{
    gap: 6px !important; 
    width: 100% !important;
}}
[data-testid="stSidebar"] [data-testid="stRadio"] label {{
    background-color: transparent !important;
    border: none !important;
    color: white !important;
    padding: 8px 0px !important;
    margin: 0px !important;
    cursor: pointer !important;
    transition: all 0.2s ease;
}}
[data-testid="stSidebar"] [data-testid="stRadio"] label:has(input:checked) p {{
    color: #FFFFFF !important;     
    font-weight: 800 !important;   
    font-size: 18px !important;    
    border-left: 4px solid #FFFFFF !important; 
    padding-left: 10px !important; 
}}
[data-testid="stSidebar"] [data-testid="stRadio"] label:not(:has(input:checked)) p {{
    color: rgba(255, 255, 255, 0.6) !important; 
    font-weight: 500 !important;
    font-size: 16px !important;
    padding-left: 14px !important; 
}}
[data-testid="stSidebar"] [data-testid="stRadio"] label:hover p {{
    /* No Hover Effect */
}}
[data-testid="stSidebar"] h1 {{
    color: white !important;
    font-size: 24px !important;
    font-weight: 700 !important;
    margin-bottom: 20px !important;
}}

/* FIX: Ensure st.metric value in Character mode is black */
[data-testid="stMetric"] > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) {{
    color: {TEXT_COLOR} !important;
}}

/* Custom container style for Map/List States to match global card style */
.card-container {{
    background-color: {WHITE}; 
    border-radius: 12px; 
    border: 1px solid #e0e0e0; 
    box-shadow: 0px 4px 12px rgba(0,0,0,0.05); 
    padding: 15px; 
    height: 100%;
}}

/* ==================================== */
/* FIND TAB SPECIFIC STYLES (Disesuaikan untuk Font Rapi) */
/* ==================================== */
.find-metric-value-text {{
    font-weight: 700;
    color: {TEXT_COLOR}; 
    line-height: 1.2;
    word-wrap: break-word;
}}
.find-metric-label-text {{
    /* Semi-bold untuk header */
    font-size: 16px;
    font-weight: 600; 
    color: {TEXT_COLOR}; 
    opacity: 0.8;
    margin-bottom: 5px;
}}
.find-card-base {{
    background-color: {WHITE}; 
    border-radius:12px; 
    box-shadow:0px 4px 12px rgba(0,0,0,0.05); /* Card-Container Shadow */
    border: 1px solid #e0e0e0;
    padding:15px; 
    width:100%; 
    height:130px; 
    font-family:'Source Sans Pro', sans-serif;
    display: flex;
    flex-direction: column;
    justify-content: center;
    text-align: center;
}}
.find-card-accent {{
    background-color: {LIGHT_ACCENT_COLOR}; 
    border: 1px solid {LIGHT_ACCENT_COLOR};
}}
.find-card-accent .find-metric-label-text, .find-card-accent .find-metric-value-text {{
    color: {WHITE} !important;
}}
/* ==================================== */
</style>
"""
st.markdown(custom_css, unsafe_allow_html=True)


# =============================
# DATA LOADING
# =============================
@st.cache_data
def load_data(file_path):
    try:
        df = pd.read_csv(file_path)
        df["Order Date"] = pd.to_datetime(df["Order Date"])
        df["Year"] = df["Order Date"].dt.year

        if "Ship Date" in df.columns:
            df["Ship Duration"] = (
                pd.to_datetime(df["Ship Date"]) - df["Order Date"]
            ).dt.days
        else:
            df["Ship Duration"] = 3.5

        return df

    except Exception as e:
        st.error(f"Error loading data: {e}")
        return pd.DataFrame()


@st.cache_data
def load_clustering_data(file_path):
    try:
        df = pd.read_csv(file_path)

        if "Purchase Type" not in df.columns:
            df["Purchase Type"] = np.random.choice(
                ["Online", "Store", "Call"], size=len(df)
            )

        return df

    except Exception as e:
        st.error(f"Error loading clustering data: {e}")
        return pd.DataFrame()

# =============================
# MODEL LOADING
# =============================
@st.cache_resource
def load_ml_assets():
    scaler_path = os.path.join(MODEL_DIR, "scaler_clustering.pkl")
    model_path = os.path.join(MODEL_DIR, "model_clustering.pkl")

    if not os.path.exists(scaler_path):
        raise FileNotFoundError("scaler_clustering.pkl tidak ditemukan")
    if not os.path.exists(model_path):
        raise FileNotFoundError("model_clustering.pkl tidak ditemukan")

    scaler = joblib.load(scaler_path)
    kmeans_model = joblib.load(model_path)

    return scaler, kmeans_model

# =============================
# LOAD DATASET
# =============================
data_clean_path = os.path.join(DATASET_DIR, "data_clean.csv")
data_cluster_path = os.path.join(DATASET_DIR, "data_clustering.csv")

data = load_data(data_clean_path)
df_rfm = load_clustering_data(data_cluster_path)

# =============================
# LOAD MODEL
# =============================
try:
    scaler, kmeans_model = load_ml_assets()
except Exception as e:
    st.error(str(e))
    st.stop()

# --- MODEL SIMULATION & REKOMENDASI ---
# Data Rekomendasi berdasarkan image_1ab8bc.png
CLUSTER_MAPPING = { 
    0: {"name": "Potential Loyalists 📈", "reco": ["Adams Telephone Message Book", "3-Hole Punch", "Acco D-Ring Binder w/DublLock"]},
    1: {"name": "At Risk ⚠️", "reco": ["Aluminum Screw Posts", "12-1/2 Diameter Round Wall Clock", "4009 Highlighters by Sanford"]},
    2: {"name": "Champions 🏆", "reco": ["ACCOHIDE 3-Ring Binder, Blue, 1\"", "3M Hangers with Command Adhesive", "#10 White Business Envelopes"]}
}

@st.cache_resource
def load_ml_assets():
    scaler = joblib.load(os.path.join(BASE_DIR, "model", "scaler_clustering.pkl"))
    kmeans_model = joblib.load(os.path.join(BASE_DIR, "model", "model_clustering.pkl"))
    return scaler, kmeans_model

scaler, kmeans_model = load_ml_assets()

try:
    scaler, kmeans_model = load_ml_assets()
except Exception as e:
    st.error("Model clustering tidak ditemukan. Pastikan file .pkl tersedia.")
    st.stop()

def predict_segment(recency, frequency, monetary):
    X = pd.DataFrame([{
        "Recency": recency,
        "Frequency": frequency,
        "Monetary": monetary
    }])

    X_scaled = scaler.transform(X)
    cluster = kmeans_model.predict(X_scaled)[0]
    return cluster

# Data loading
try:
    data = load_data("data_clean.csv")
    df_rfm = load_clustering_data("data_clustering.csv")
    
    # Pre-load/Simulate ML assets
    load_ml_assets()

    if data.empty or df_rfm.empty: 
        st.stop()
    
    # Ensure Customer ID column exists in data for join/lookup
    if 'Customer ID' not in data.columns:
        data['Customer ID'] = data['Customer Name'].apply(lambda x: f"CUST_{hash(x) % 1000}")

    # Ensure Segment Name exists in df_rfm for the Find tab
    cluster_mapping = { 2: "Champions 🏆", 0: "Potential Loyalists 📈", 1: "At Risk ⚠️" }
    if 'Cluster' in df_rfm.columns and 'Segment Name' not in df_rfm.columns:
         df_rfm['Segment Name'] = df_rfm['Cluster'].map(cluster_mapping)


    all_years = sorted(data['Year'].unique(), reverse=True)
except Exception as e:
    st.error(f"Failed to initialize application due to data error: {e}")
    st.stop()


# --- TEMPLATE PLOTLY PUTIH ---
def get_light_plot_template():
    # FIX: Menambahkan pengaturan untuk Tooltip text color (warna font tooltip)
    return dict(
        layout=dict(
            plot_bgcolor=WHITE,  
            paper_bgcolor=WHITE, 
            font=dict(color="#000000", family="'Source Sans Pro', sans-serif"), 
            colorway=[ACCENT_COLOR, '#3CB371', '#FFD700', '#FF6347', '#4682B4'],
            title=dict(
                x=0.02, 
                # Pastikan title font color diatur ke hitam
                font=dict(size=18, weight='bold', family="'Source Sans Pro', sans-serif", color="#000000"),
                pad=dict(t=15)
            ),
            margin=dict(t=60, l=20, r=20, b=20), 
            # FIX: Tooltip/Hover label font color
            hoverlabel=dict(font=dict(color=TEXT_COLOR)),
            # GEO di Plotly Map Default background putih
            geo=dict(bgcolor=WHITE, lakecolor=WHITE, landcolor=WHITE, showland=True, showlakes=False),
            # AXIS WARNA HITAM
            xaxis=dict(
                showgrid=True, gridcolor="#f0f0f0", linecolor="#000000", zeroline=True, zerolinecolor="#000000",
                tickfont=dict(color="#000000", family="'Source Sans Pro', sans-serif"), title_font=dict(color="#000000", family="'Source Sans Pro', sans-serif")
            ),
            yaxis=dict(
                showgrid=False, linecolor="#000000",
                tickfont=dict(color="#000000", family="'Source Sans Pro', sans-serif"), title_font=dict(color="#000000", family="'Source Sans Pro', sans-serif")
            ),
            # LEGEND TITLE HITAM (Default)
            legend=dict(font=dict(color="#000000", family="'Source Sans Pro', sans-serif"), title=dict(font=dict(color="#000000"))), 
            uniformtext=dict(minsize=8, mode='show') 
        )
    )

def handle_view_change(new_view):
    st.session_state['view_option'] = new_view

def handle_seg_view_change(new_view):
    st.session_state['seg_view_option'] = new_view

# --- METRIC CARD (DEFAULT UNTUK OVERVIEW & RFM GLOBAL UNGU) ---
def custom_metric_card(label, value, bg_color, text_color):
    return f"""
        <div style="
            background-color:{bg_color}; 
            border-radius:12px; 
            box-shadow:0px 6px 12px rgba(0,0,0,0.1); 
            padding:15px; 
            width:100%; 
            box-sizing: border-box;
            height:100%; 
            font-family:'Source Sans Pro', sans-serif;
        ">
            <div style="font-size:20px; font-weight:bold; color:{text_color}; opacity:0.8; margin-bottom:5px;">{label}</div>
            <div style="font-size:32px; color:{text_color};">{value}</div>
        </div>
    """

# --- METRIC CARD DINAMIS (Untuk R, F, M di Character Mode) ---
def dynamic_metric_card(label, value):
    bg = WHITE
    text = TEXT_COLOR
    border = '1px solid #e0e0e0'
    
    return f"""
        <div style="
            background-color:{bg}; 
            border-radius:12px; 
            box-shadow:0px 2px 5px rgba(0,0,0,0.05); /* Shadow tipis agar kontras */
            border: {border};
            padding:15px; 
            width:100%; 
            box-sizing: border-box;
            height:100%; 
            font-family:'Source Sans Pro', sans-serif;
        ">
            <div style="font-size:16px; font-weight:600; color: #666; opacity:0.9; margin-bottom:5px;">{label}</div>
            <div style="font-size:32px; color:{text};">{value}</div>
        </div>
    """

# --- CARD KHUSUS UNTUK TOP FEATURES (Disesuaikan FONT & SHADOW) ---
def top_feature_card(label, value, is_accent=False):
    # Penyesuaian Font Size berdasarkan panjang value
    value_font_size = "24px" if len(str(value)) <= 20 else "20px"
    value_line_height = "1.2" if len(str(value)) > 20 else "1"
    
    # Class untuk styling card (putih shadow atau ungu)
    card_class = "find-card-accent" if is_accent else "find-card-base"
    
    # Menentukan warna teks (Putih jika accent, Hitam jika tidak)
    text_color = WHITE if is_accent else TEXT_COLOR
    label_opacity = 1.0 # Opacity 1.0 agar semi-bold terlihat jelas

    return f"""
        <div class="{card_class}">
            <div class="find-metric-label-text" style="
                font-weight: 600 !important; /* Semi-bold */
                color: {text_color} !important;
                opacity: {label_opacity} !important; 
            ">
                {label}
            </div>
            <div class="find-metric-value-text" style="
                font-size:{value_font_size}; 
                color:{text_color} !important;
                line-height:{value_line_height};
            ">
                {value}
            </div>
        </div>
    """

# --- CUSTOM INSIGHT BOX (LIGHT PURPLE) ---
def custom_insight_box(icon, text):
    return f"""
        <div style="
            background-color:{LIGHT_ACCENT_COLOR}; 
            color: {WHITE}; 
            padding: 10px 15px; 
            border-radius: 8px; 
            font-size: 16px; 
            font-weight: 600;
            line-height: 1.5;
            font-family: 'Source Sans Pro', sans-serif;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
        ">
            {icon} <span style="margin-left: 8px; color: {WHITE} !important;">{text}</span>
        </div>
        """

def get_insight_text(segment_name, revenue_share):
    """Menghasilkan kalimat insight dinamis berdasarkan segmen."""
    # Menggunakan HTML tag <b> untuk bold di output st.markdown
    base_text = f"Segmen <b>{segment_name}</b> menyumbang sekitar <b>{revenue_share:.1f}%</b> dari total pendapatan."
    
    if "Champions" in segment_name:
        return base_text + " Ini menegaskan peran mereka sebagai sumber pendapatan utama yang stabil dan berulang. Pertahankan loyalitas mereka dengan program eksklusif."
    elif "Loyalists" in segment_name:
        return base_text + " Segmen ini menunjukkan potensi besar untuk tumbuh menjadi Champions. Program insentif retensi bertarget dapat meningkatkan frekuensi pembelian mereka."
    elif "At Risk" in segment_name:
        return base_text + " Kontribusi yang rendah (atau menurun) mengindikasikan bahwa pelanggan ini berisiko hilang. Prioritaskan strategi reaktivasi dan penawaran khusus untuk menarik mereka kembali."
    else:
        return base_text

# --- MAIN PAGE: OVERVIEW ---
def show_overview_page(data, all_years):
    st.markdown(f"<h1 style='font-size: 40px; font-weight: bold; color: {TEXT_COLOR}; font-family: \"Source Sans Pro\", sans-serif;'>🚀 Overview Penjualan</h1>", unsafe_allow_html=True)
    
    total_orders = data['Order ID'].nunique()
    total_revenue = data['Sales'].sum()
    total_customer = data['Customer Name'].nunique() 
    avg_ship_duration = data['Ship Duration'].median() 
    
    top_sub = data.groupby("Sub-Category")["Sales"].sum().nlargest(5)
    total_sales = data["Sales"].sum()
    
    top5_html = ""
    for i, (k, v) in enumerate(top_sub.items(), 1):
        pct = v / total_sales * 100
        width = v / top_sub.max() * 100
        top5_html += f"""
            <div style="margin-bottom:12px; color: {TEXT_COLOR}; font-family: 'Source Sans Pro', sans-serif;">
                <b>{i}. {k}</b> — ${v/1000:,.0f}K ({pct:.1f}%)
                <div style="background:#f0f0f0; border-radius:6px; height:6px; margin-top:4px;">
                    <div style="width:{width:.0f}%; height:6px; border-radius:6px; background:{ACCENT_COLOR};"></div>
                </div>
            </div>"""

    c1, c2, c3 = st.columns([1.5, 1.5, 2.5]) 
    with c1:
        components.html(custom_metric_card("Total Order", f"{total_orders:,}", LIGHT_ACCENT_COLOR, WHITE), height=130)
        components.html(custom_metric_card("Avg Ship", f"{avg_ship_duration:,.1f} Days", WHITE, TEXT_COLOR), height=130)
    with c2:
        components.html(custom_metric_card("Total Revenue", f"${total_revenue:,.0f}", WHITE, TEXT_COLOR), height=130)
        components.html(custom_metric_card("Total Customer", f"{total_customer:,}", WHITE, TEXT_COLOR), height=130)
    with c3:
        components.html(f"""
            <div class="card-container" style="height:330px; box-sizing:border-box;">
                <h4 style="margin:0 0 5px 0; font-size:24px; font-weight:bold; color:{TEXT_COLOR}; font-family: 'Source Sans Pro', sans-serif;">Top 5 Revenue Drivers</h4>
                <p style="font-size:13px; color:{TEXT_COLOR}; margin:8px 0 15px 0; font-family: 'Source Sans Pro', sans-serif;">Contribution to Total Sales</p>
                {top5_html}
            </div>""", height=330)

    st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True) 

    cn1, cn2, cn3, _ = st.columns([1, 1, 1, 4])
    labels = ["Order Detail", "Sales Performance", "Ship Modes"]
    
    for i, lbl in enumerate(labels):
        with [cn1, cn2, cn3][i]:
            if st.button(lbl, key=f"btn_{i}", use_container_width=True, on_click=handle_view_change, args=(lbl,)): pass
            if st.session_state['view_option'] == lbl:
                st.markdown(f"""
                <style>
                div[data-testid='stHorizontalBlock'] > div:nth-child({i+1}) button {{ 
                    background-color: {ACCENT_COLOR} !important; 
                    border: 1px solid {ACCENT_COLOR} !important; 
                    color: white !important;
                }}
                </style>
                """, unsafe_allow_html=True)

    plot_tmpl = get_light_plot_template()
    view = st.session_state['view_option'] or 'Sales Performance'

    if view == 'Order Detail':
        st.markdown("<div style='height: 30px;'></div>", unsafe_allow_html=True)
        c_map, c_bar = st.columns([2, 3])
        CHART_HEIGHT = 450 

        with c_map:
            state_data = data.groupby('State')['Order ID'].nunique().reset_index()
            state_data.columns = ['State', 'Val']
            state_data['Code'] = state_data['State'].map(US_STATE_TO_CODE)
            fig_map = px.choropleth(state_data, locations='Code', locationmode='USA-states', color='Val', scope='usa',
                                    title='<b>Map Order per State</b>', color_continuous_scale=[WHITE, ACCENT_COLOR],
                                    template=plot_tmpl)
            fig_map.update_layout(
                margin=dict(l=10, r=10, t=50, b=10), 
                paper_bgcolor=WHITE, plot_bgcolor=WHITE, geo=dict(bgcolor=WHITE), 
                coloraxis_colorbar=dict(title=dict(text="Orders", font=dict(color=TEXT_COLOR, size=11)), tickfont=dict(color=TEXT_COLOR, size=10))
            )
            config = {'scrollZoom': False, 'displayModeBar': False}
            st.plotly_chart(fig_map, use_container_width=True, theme=None, height=CHART_HEIGHT, config=config)

        with c_bar:
            top_st = data.groupby('State')['Order ID'].nunique().nlargest(10).reset_index().sort_values('Order ID')
            top_st['Pct_Text'] = (top_st['Order ID'] / data['Order ID'].nunique()).apply(lambda x: f"{x:.1%}")
            fig_bar = px.bar(top_st, x='Order ID', y='State', orientation='h', title="<b>Top 10 State by Orders (Share %)</b>", text='Pct_Text')
            
            # PENYESUAIAN GRAFIK: Margin dan Font (memastikan rapi)
            fig_bar.update_traces(texttemplate='<b>%{text}</b>', textposition='outside', cliponaxis=False, marker_color=ACCENT_COLOR, textfont=dict(color=TEXT_COLOR, weight='bold'))
            fig_bar.update_layout(
                template=plot_tmpl,
                paper_bgcolor=WHITE, 
                plot_bgcolor=WHITE, 
                xaxis=dict(showticklabels=False, showgrid=False, title='Order Count', title_font=dict(color=TEXT_COLOR)), # Tambah title_font
                yaxis=dict(categoryorder='total ascending', automargin=True, title=None, tickfont=dict(color=TEXT_COLOR)), # Hapus title=State
                margin=dict(l=150, r=60, t=50, b=50) # Margin kiri 150 untuk nama state yang panjang
            )
            st.plotly_chart(fig_bar, use_container_width=True, theme=None)

    elif view == 'Sales Performance':
        st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True)
        col_filters_sales, col_dummy = st.columns([1, 4])
        with col_filters_sales:
            selected_years_sales = st.multiselect('Pilih Tahun:', options=all_years, default=all_years, key='sales_year_filter_ov')
        st.markdown("<div style='height: 25px;'></div>", unsafe_allow_html=True)
        filtered_data_sales = data[data['Year'].isin(selected_years_sales)]
        if filtered_data_sales.empty: st.warning("Tidak ada data.")
        else:
            sales_trend = filtered_data_sales.groupby(pd.Grouper(key='Order Date', freq='M'))['Sales'].sum().reset_index()
            fig = px.line(sales_trend, x='Order Date', y='Sales', title='<b>Tren Penjualan Bulanan</b>', template=plot_tmpl)
            fig.update_layout(paper_bgcolor=WHITE, plot_bgcolor=WHITE, margin=dict(t=50, b=80, l=60, r=20), hovermode="x unified")
            st.plotly_chart(fig, use_container_width=True, theme=None)
            st.markdown("<div style='height: 40px;'></div>", unsafe_allow_html=True)
            c1, c2 = st.columns(2)
            CHART_HEIGHT_SMALL = 400
            with c1:
                top_prod = filtered_data_sales.groupby('Product Name')['Sales'].sum().nlargest(10).reset_index().sort_values('Sales')
                top_prod['ShortName'] = top_prod['Product Name'].apply(lambda x: x[:30] + '...' if len(x) > 30 else x)
                top_prod['Sales_Text'] = top_prod['Sales'].apply(lambda x: f"${x/1000:,.1f}k")
                fig = px.bar(top_prod, x='Sales', y='ShortName', orientation='h', title='<b>Top 10 Produk (Revenue)</b>', template=plot_tmpl, text='Sales_Text')
                
                # PENYESUAIAN GRAFIK: Margin dan Font (merapikan sumbu Y)
                fig.update_traces(texttemplate='<b>%{text}</b>', textposition='outside', cliponaxis=False, marker_color=ACCENT_COLOR, textfont=dict(color=TEXT_COLOR))
                fig.update_layout(
                    paper_bgcolor=WHITE, 
                    plot_bgcolor=WHITE, 
                    xaxis=dict(showticklabels=False, title='Count', title_font=dict(color=TEXT_COLOR)),
                    yaxis=dict(categoryorder='total descending', automargin=True, title=None, tickfont=dict(color=TEXT_COLOR)), # Auto margin untuk Y axis
                    margin=dict(l=150, r=40, t=50, b=20), # Menambah margin kiri
                    showlegend=False
                )
                st.plotly_chart(fig, use_container_width=True, theme=None, height=CHART_HEIGHT_SMALL)
            with c2:
                top_st = filtered_data_sales.groupby('State')['Sales'].sum().nlargest(10).reset_index().sort_values('Sales')
                top_st['Sales_Text'] = top_st['Sales'].apply(lambda x: f"${x/1000:,.1f}k")
                fig = px.bar(top_st, x='Sales', y='State', orientation='h', title='<b>Top 10 State (Revenue)</b>', template=plot_tmpl, text='Sales_Text')
                fig.update_traces(texttemplate='<b>%{text}</b>', textposition='outside', cliponaxis=False, marker_color=ACCENT_COLOR, textfont=dict(color=TEXT_COLOR))
                fig.update_layout(paper_bgcolor=WHITE, plot_bgcolor=WHITE, xaxis=dict(showticklabels=False), yaxis=dict(categoryorder='total ascending'), margin=dict(l=120, r=40, t=50, b=20))
                st.plotly_chart(fig, use_container_width=True, theme=None)

    elif view == 'Ship Modes':
        st.markdown("<div style='height: 25px;'></div>", unsafe_allow_html=True)
        all_modes = sorted(data['Ship Mode'].unique().tolist())
        selected_ship_modes = st.multiselect("Pilih Ship Mode:", options=all_modes, default=all_modes, key='ship_mode_top_filter')
        st.markdown("<div style='height: 25px;'></div>", unsafe_allow_html=True)
        if not selected_ship_modes: st.warning("Pilih mode.")
        else:
            df_filtered = data[data['Ship Mode'].isin(selected_ship_modes)]
            title_bar = "<b>Total Orders per State</b>"
            total_context = df_filtered['Order ID'].nunique()
            c1, c2 = st.columns([1, 2])
            with c1:
                ship_counts = df_filtered['Ship Mode'].value_counts().reset_index()
                ship_counts.columns = ['Mode', 'Count']
                fig_pie = px.pie(ship_counts, values='Count', names='Mode', hole=.4, title='<b>Distribusi Ship Mode</b>', template=plot_tmpl)
                fig_pie.update_layout(paper_bgcolor=WHITE, plot_bgcolor=WHITE, margin=dict(t=60, b=30, r=30, l=30))
                st.plotly_chart(fig_pie, use_container_width=True, theme=None)
            with c2:
                df_bar = df_filtered.groupby('State')['Order ID'].nunique().reset_index()
                df_bar.columns = ['State', 'Total Orders']
                df_bar_sorted = df_bar.sort_values(by='Total Orders', ascending=False).head(20).sort_values(by='Total Orders', ascending=True)
                df_bar_sorted['Pct_Text'] = (df_bar_sorted['Total Orders'] / total_context).apply(lambda x: f"{x:.1%}")
                fig = px.bar(df_bar_sorted, x='Total Orders', y='State', orientation='h', title=title_bar, text='Pct_Text', template=plot_tmpl)
                
                # PENYESUAIAN GRAFIK: Margin, Sumbu X, dan Hapus Persen
                fig.update_traces(text=None, texttemplate=None, textposition='none', cliponaxis=False, marker_color=ACCENT_COLOR, textfont=dict(color=TEXT_COLOR))
                fig.update_layout(
                    paper_bgcolor=WHITE, 
                    plot_bgcolor=WHITE, 
                    xaxis=dict(showticklabels=True, title='Total Orders'), # Menampilkan kembali ticklabels untuk sumbu X
                    yaxis=dict(categoryorder='total ascending', automargin=True, title=None), # Hapus title=State
                    margin=dict(l=150, r=40, t=50, b=20) # Menambah margin kiri menjadi 150
                )
                st.plotly_chart(fig, use_container_width=True, theme=None)

# --- NEW PAGE: CUSTOMER SEGMENTATION (RFM) ---
def show_segmentation_page():
    # 1. TAMBAH HEADER PAGE
    st.markdown(f"<h1 style='font-size: 40px; font-weight: bold; color: {TEXT_COLOR}; font-family: \"Source Sans Pro\", sans-serif;'>👥 Customer Segmentation (RFM)</h1>", unsafe_allow_html=True)
    st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True)

    try:
        df_rfm = load_clustering_data("data_clustering.csv")
        cluster_mapping = { 2: "Champions 🏆", 0: "Potential Loyalists 📈", 1: "At Risk ⚠️" }
        df_rfm['Segment Name'] = df_rfm['Cluster'].map(cluster_mapping)
    except:
        st.error("Error processing segmentation data.")
        return

    # 1. RINGKASAN CLUSTER (CARDS - Atas) - TEXT SEMUA HITAM
    cluster_summary = df_rfm.groupby('Segment Name').agg({
        'Customer ID': 'count',
        'Monetary': 'mean'
    }).reset_index().rename(columns={'Customer ID': 'Count', 'Monetary': 'Avg Sales'})

    cols = st.columns(3)
    for index, row in cluster_summary.iterrows():
        seg_name = row['Segment Name']
        count = row['Count']
        avg_sales = row['Avg Sales']
        with cols[index % 3]:
            # HTML KHUSUS UNTUK CARD
            st.markdown(f"""
            <div class="card-container" style="height: 180px; display: flex; flex-direction: column; justify-content: space-between; margin-bottom: 10px;">
                <div style="color: {TEXT_COLOR}; font-size: 20px; font-weight: 700;">
                    {seg_name}
                </div>
                <div style="font-size: 42px; font-weight: 600; color: {TEXT_COLOR}; line-height: 1;">
                    {count:,}
                    <span style="font-size: 14px; font-weight: 400; color: {TEXT_COLOR}; opacity: 0.7; margin-left: 5px;">Customers</span>
                </div>
                <div style="
                    background-color: #F8F9FA; 
                    padding: 8px 12px; 
                    border-radius: 8px; 
                    display: flex; 
                    align-items: center; 
                    justify-content: space-between;
                ">
                    <span style="font-size: 14px; color: {TEXT_COLOR}; opacity: 0.8;">Avg Sales:</span>
                    <span style="font-size: 16px; font-weight: 700; color: {TEXT_COLOR};">${avg_sales:,.0f}</span>
                </div>
            </div>
            """, unsafe_allow_html=True)

    st.markdown("<div style='height: 30px;'></div>", unsafe_allow_html=True)

    # 2. METRIKS GLOBAL RFM (Tengah) - KEMBALI KE UNGU (GLOBAL RFM CARDS)
    global_recency = df_rfm['Recency'].mean()
    global_frequency = df_rfm['Frequency'].mean()
    global_monetary = df_rfm['Monetary'].mean()

    c1, c2, c3 = st.columns(3)
    # CARD UNGU GLOBAL RFM (TETAP ADA)
    with c1: components.html(custom_metric_card("Avg Recency (Global)", f"{global_recency:.1f} Days", LIGHT_ACCENT_COLOR, WHITE), height=130)
    with c2: components.html(custom_metric_card("Avg Frequency (Global)", f"{global_frequency:.1f} Orders", LIGHT_ACCENT_COLOR, WHITE), height=130)
    with c3: components.html(custom_metric_card("Avg Monetary (Global)", f"${global_monetary:,.0f}", LIGHT_ACCENT_COLOR, WHITE), height=130)

    # FIX: Jarak antar Button ke Card RFM
    st.markdown("<div style='height: 30px;'></div>", unsafe_allow_html=True)

    # 3. NAVIGATION BUTTONS
    c_btn1, c_btn2, c_btn3, _ = st.columns([1, 1, 1, 3])
    seg_labels = ["Explanation", "Character", "Find"]
    
    for i, lbl in enumerate(seg_labels):
        with [c_btn1, c_btn2, c_btn3][i]:
            if st.button(lbl, key=f"seg_btn_{i}", use_container_width=True, on_click=handle_seg_view_change, args=(lbl,)): pass
            if st.session_state['seg_view_option'] == lbl:
                st.markdown(f"""
                <style>
                div[data-testid='stHorizontalBlock'] > div:nth-child({i+1}) button {{ 
                    background-color: {ACCENT_COLOR} !important; 
                    border: 1px solid {ACCENT_COLOR} !important; 
                    color: white !important;
                }}
                div[data-testid='stHorizontalBlock'] > div:nth-child({i+1}) button p,
                div[data-testid='stHorizontalBlock'] > div:nth-child({i+1}) button div {{
                    color: white !important;
                }}
                </style>
                """, unsafe_allow_html=True)
    
    st.markdown("<div style='height: 20px;'></div>", unsafe_allow_html=True)
    
    view = st.session_state['seg_view_option']
    plot_tmpl = get_light_plot_template()

    # --- VIEW: EXPLANATION ---
    if view == 'Explanation':
        c1, c2 = st.columns(2)
        with c1:
            # 3D Scatter 
            fig_3d = px.scatter_3d(df_rfm, x='Recency', y='Frequency', z='Monetary', color='Segment Name',
                                   title='<b>3D RFM Distribution</b>', opacity=0.7, template=plot_tmpl,
                                   color_discrete_sequence=COLD_PALETTE)
            fig_3d.update_layout(
                paper_bgcolor=WHITE, plot_bgcolor=WHITE, 
                margin=dict(l=0, r=0, t=20, b=60), 
                scene = dict(
                    bgcolor=WHITE, 
                    xaxis = dict(title='Recency', title_font=dict(color="black"), tickfont=dict(color="black")), 
                    yaxis = dict(title='Frequency', title_font=dict(color="black"), tickfont=dict(color="black")), 
                    zaxis = dict(title='Monetary', title_font=dict(color="black"), tickfont=dict(color="black"))
                ),
                legend=dict(font=dict(color="black"), title=dict(font=dict(color="black", size=14), text="Segment Name")) 
            )
            st.plotly_chart(fig_3d, use_container_width=True)
        
        with c2:
            # Centroid Profile (HEATMAP)
            centroid = df_rfm.groupby('Segment Name')[['Recency', 'Frequency', 'Monetary']].mean()
            fig_heat = px.imshow(centroid, text_auto=".1f", color_continuous_scale="Purples",
                                 title="<b>Centroid Profile (Avg Values)</b>")
            fig_heat.update_layout(
                paper_bgcolor=WHITE, plot_bgcolor=WHITE, 
                font=dict(color="black"),
                xaxis=dict(tickfont=dict(color="black"), title_font=dict(color="black")), 
                yaxis=dict(tickfont=dict(color="black"), title_font=dict(color="black")) 
            )
            st.plotly_chart(fig_heat, use_container_width=True)

    # --- VIEW: CHARACTER ---
    elif view == 'Character':
        c_left, c_right = st.columns([1, 2])
        
        # --- Kolom Kiri: Donut Chart ---
        with c_left:
            seg_counts = df_rfm['Segment Name'].value_counts().reset_index().rename(columns={'count': 'Count', 'Segment Name': 'Segment'})
            fig_donut = px.pie(seg_counts, values='Count', names='Segment', hole=0.4, 
                               title='<b>Segment Proportion</b>', color_discrete_sequence=COLD_PALETTE, template=plot_tmpl)
            fig_donut.update_layout(
                paper_bgcolor=WHITE, plot_bgcolor=WHITE, 
                margin=dict(t=40, b=20, l=20, r=20), 
                legend=dict(font=dict(color="black"), title=dict(font=dict(color="black")))
            )
            st.plotly_chart(fig_donut, use_container_width=True)

        # --- Kolom Kanan: Dropdown dan Dynamic Metrics ---
        with c_right:
            selected_segment = st.selectbox("Select Segment to Analyze:", options=["Champions 🏆", "Potential Loyalists 📈", "At Risk ⚠️"])
            seg_data = df_rfm[df_rfm['Segment Name'] == selected_segment]
            
            # Perhitungan Dynamic Metrics
            avg_r = seg_data['Recency'].mean()
            avg_f = seg_data['Frequency'].mean()
            avg_m = seg_data['Monetary'].mean()
            
            seg_rev = seg_data['Monetary'].sum()
            total_rev = df_rfm['Monetary'].sum()
            rev_share = (seg_rev / total_rev) * 100

            st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True)

            # 3 Card RFM Dinamis
            cc1, cc2, cc3 = st.columns(3)
            with cc1: components.html(dynamic_metric_card("Avg Recency", f"{avg_r:.1f} Days"), height=100)
            with cc2: components.html(dynamic_metric_card("Avg Frequency", f"{avg_f:.1f} Orders"), height=100)
            with cc3: components.html(dynamic_metric_card("Avg Monetary", f"${avg_m:,.0f}"), height=100)
            
            st.markdown("<div style='height: 15px;'></div>", unsafe_allow_html=True)
            
            # Insight Kontribusi Revenue (Single Metric)
            st.metric(
                label=f"Revenue Contribution ({selected_segment})", 
                value=f"{rev_share:.1f}%",
                delta_color="off"
            )
            
            # Kalimat Business Insight Dinamis
            insight_text = get_insight_text(selected_segment, rev_share)
            st.markdown(f"""
            <div style="margin-top: 15px; padding: 10px 0; border-top: 1px dashed #e0e0e0; font-family: 'Source Sans Pro', sans-serif;">
                <p style="font-size: 16px; color: {TEXT_COLOR};">
                    <span style="font-weight: 700;">Business Insight:</span> 
                    {insight_text}
                </p>
            </div>
            """, unsafe_allow_html=True)
            st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True)


        st.markdown("<hr>", unsafe_allow_html=True)

        # --- BARIS 3: MAP + LIST STATES ---
        
        # Persiapan data untuk List States
        state_counts_df = seg_data.groupby('State')['Customer ID'].nunique().reset_index()
        state_counts_df.columns = ['State', 'Count']
        state_counts_sorted = state_counts_df.sort_values(by='Count', ascending=False).head(10)

        # Membuat list HTML untuk ditampilkan di sebelah kanan map
        list_states_html = ""
        if not state_counts_sorted.empty:
            # Judul List States
            list_states_html += f"<h4 style='font-size: 24px; font-weight: 700; color: {TEXT_COLOR}; margin-bottom: 15px; font-family: \"Source Sans Pro\", sans-serif;'>Top 10 States by Customer Count</h4>"
            list_states_html += "<ul style='list-style-type: none; padding-left: 0; font-family: \"Source Sans Pro\", sans-serif;'>"
            for index, row in state_counts_sorted.iterrows():
                # Font list item (Hitam)
                list_states_html += f"<li style='margin-bottom: 8px; font-size: 16px; color: {TEXT_COLOR};'><b>{row['State']}</b>: {row['Count']:,} Customers</li>"
            list_states_html += "</ul>"
        else:
             list_states_html += f"<div style='font-size: 18px; color: #666;'>No state data available for {selected_segment}.</div>"

        # Layout 1 Baris: Map (2/3 lebar) dan List States (1/3 lebar)
        c_map, c_list = st.columns([2, 1])

        with c_map:
            st.markdown(f"<h3><b>Map Customer Density</b></h3>", unsafe_allow_html=True)
            
            state_counts = seg_data.groupby('State')['Customer ID'].nunique().reset_index()
            state_counts.columns = ['State', 'Count']
            state_counts['Code'] = state_counts['State'].map(US_STATE_TO_CODE)
            fig_map = px.choropleth(state_counts, locations='Code', locationmode='USA-states', color='Count', scope='usa', title=None, color_continuous_scale='Purples', template=plot_tmpl)
            
            fig_map.update_layout(
                margin=dict(l=0, r=0, t=20, b=0), 
                paper_bgcolor=WHITE, plot_bgcolor=WHITE, 
                geo=dict(bgcolor=WHITE, lakecolor=WHITE, landcolor=WHITE, projection_type='albers usa'),
                coloraxis_colorbar=dict(
                    title=dict(font=dict(color=TEXT_COLOR)),
                    tickfont=dict(color=TEXT_COLOR)
                )
            )
            st.plotly_chart(fig_map, use_container_width=True, height=450) 

        with c_list:
            st.markdown("<div style='height: 40px;'></div>", unsafe_allow_html=True) # Spacer agar sejajar dengan map
            components.html(f"""
                <div class="card-container" style="padding:15px; height: 490px; overflow-y: auto;">
                    {list_states_html}
                </div>
            """, height=490) 
        
        st.markdown("<div style='height: 40px;'></div>", unsafe_allow_html=True)
        
        # --- BARIS 4: PRODUCT & SHIPMENT PREFERENCE (FIXED SORTING & COLOR & INSIGHT BOX) ---
        c_prod, c_ship = st.columns(2)
        CHART_HEIGHT_SMALL = 400

        with c_prod:
            # Top Product (FIXED SORTING & FONT COLOR)
            prod_cols = ['Furniture_Count', 'Office Supplies_Count', 'Technology_Count']
            prod_sum = seg_data[[col for col in prod_cols if col in seg_data.columns]].sum().reset_index()
            prod_sum.columns = ['Type', 'Count']
            prod_sum['Type'] = prod_sum['Type'].str.replace('_Count', '')
            
            # Pra-Sortir DataFrame (Descending)
            prod_sum = prod_sum.sort_values(by='Count', ascending=False)
            
            total_items = prod_sum['Count'].sum()
            top_prod = prod_sum.iloc[0] 
            
            # FIX 1: Judul menggunakan tag bold <b>
            fig_prod = px.bar(prod_sum, x='Count', y='Type', orientation='h', title='<b>Product Type Chosed</b>', template=plot_tmpl, color_discrete_sequence=COLD_PALETTE)
            
            # PENYESUAIAN GRAFIK: Margin, Sumbu X (Title/Label), Hapus Persen
            fig_prod.update_traces(text=None, texttemplate=None, textposition='none', cliponaxis=False, marker_color=ACCENT_COLOR, textfont=dict(color=TEXT_COLOR))
            fig_prod.update_layout(
                paper_bgcolor=WHITE, 
                plot_bgcolor=WHITE, 
                # FIX Sumbu X: Tampilkan Title 'Count' dan tambahkan margin bawah
                xaxis=dict(showticklabels=True, title='Count', title_font=dict(color=TEXT_COLOR), tickfont=dict(color=TEXT_COLOR)),
                # FIX Sumbu Y: Auto margin untuk Y axis
                yaxis=dict(categoryorder='total descending', automargin=True, title=None, tickfont=dict(color=TEXT_COLOR)), 
                margin=dict(l=150, r=40, t=50, b=50), # Margin kiri 150 dan bawah 50 (supaya label X tidak mepet)
                showlegend=False
            )
            st.plotly_chart(fig_prod, use_container_width=True, height=CHART_HEIGHT_SMALL)
            
            # Box Insight Light Purple & Text Fix
            prod_text_clean = f"<b>{top_prod['Type']}</b> mendominasi ({top_prod['Count']/total_items*100:.1f}%)."
            st.markdown(custom_insight_box("💡", prod_text_clean), unsafe_allow_html=True)

        with c_ship:
            # Ship Modes (FIXED SORTING & FONT COLOR)
            ship_cols = ['First Class_Count', 'Same Day_Count', 'Second Class_Count', 'Standard Class_Count']
            ship_sum = seg_data[[col for col in ship_cols if col in seg_data.columns]].sum().reset_index()
            ship_sum.columns = ['Mode', 'Count']
            ship_sum['Mode'] = ship_sum['Mode'].str.replace('_Count', '')
            
            # Pra-Sortir DataFrame (Descending)
            ship_sum = ship_sum.sort_values(by='Count', ascending=False)
            
            top_ship = ship_sum.iloc[0] 
            total_ship = ship_sum['Count'].sum()
            
            # FIX 1: Judul menggunakan tag bold <b>
            fig_ship = px.bar(ship_sum, x='Count', y='Mode', orientation='h', title='<b>Ship Mode Chosed</b>', template=plot_tmpl, color_discrete_sequence=COLD_PALETTE)
            
            # PENYESUAIAN GRAFIK: Margin, Sumbu X (Title/Label), Hapus Persen
            fig_ship.update_traces(text=None, texttemplate=None, textposition='none', cliponaxis=False, marker_color=ACCENT_COLOR, textfont=dict(color=TEXT_COLOR))
            fig_ship.update_layout(
                paper_bgcolor=WHITE, 
                plot_bgcolor=WHITE, 
                # FIX Sumbu X: Tampilkan Title 'Count' dan tambahkan margin bawah
                xaxis=dict(showticklabels=True, title='Count', title_font=dict(color=TEXT_COLOR), tickfont=dict(color=TEXT_COLOR)),
                # FIX Sumbu Y: Jaga agar rapi (autmargin)
                yaxis=dict(title=None, categoryorder='total descending', automargin=True, tickfont=dict(color=TEXT_COLOR)), 
                margin=dict(l=120, r=40, t=50, b=50), # Menambah margin bawah
                showlegend=False
            )
            st.plotly_chart(fig_ship, use_container_width=True, height=CHART_HEIGHT_SMALL)
            
            # Box Insight Light Purple & Text Fix (Sesuai permintaan)
            ship_text_clean = f"<b>{top_ship['Mode']}</b> dipilih ({top_ship['Count']/total_ship*100:.1f}%) dari total pengiriman."
            st.markdown(custom_insight_box("🚚", ship_text_clean), unsafe_allow_html=True)


    # --- VIEW: FIND (IMPLEMENTASI FINAL KARTU RAPIH) ---
    elif view == 'Find':
        st.markdown(f"<h2>🔎 Find Customer by ID</h2>", unsafe_allow_html=True)

        # Input ID
        customer_id = st.text_input("Enter Customer ID (e.g., AA-10315)", key="find_cust_id")
        
        if customer_id:
            # 1. Cari data customer di df_rfm (data klastering)
            cust_row = df_rfm[df_rfm['Customer ID'] == customer_id]

            if cust_row.empty:
                st.warning(f"Customer ID '{customer_id}' tidak ditemukan dalam data segmentasi.")
            else:
                cust_data = cust_row.iloc[0]
                cust_monetary = cust_data['Monetary']
                cust_segment = cust_data['Segment Name']

                # 2. Tampilkan Segmentasi
                st.markdown(f"<h3>Customer Segment: <b>{cust_segment}</b></h3>", unsafe_allow_html=True)
                
                st.markdown(f"<h4>Customer Details</h4>", unsafe_allow_html=True)
                # Display data table 
                cols_to_display = ['Customer ID', 'Customer Name', 'Recency', 'Frequency', 'Monetary', 'Avg_Item_Price', 'Unique_Product_Count', 'City', 'State', 'Region']
                df_to_display = cust_row[[col for col in cols_to_display if col in cust_row.columns]].T.reset_index()
                df_to_display.columns = ['Feature', 'Value']
                st.dataframe(df_to_display, use_container_width=True) 

                st.markdown("<div style='height: 20px;'></div>", unsafe_allow_html=True)
                st.markdown(f"<h4>Top Characteristics</h4>", unsafe_allow_html=True)

                # 3. Tentukan Top Features dari data_clustering columns
                
                prod_count_cols_raw = ['Furniture_Count', 'Office Supplies_Count', 'Technology_Count']
                ship_count_cols_raw = ['First Class_Count', 'Same Day_Count', 'Second Class_Count', 'Standard Class_Count']

                # Top Product Type
                top_prod_name = "N/A"
                if any(col in cust_row.columns for col in prod_count_cols_raw):
                    prod_data = cust_data[[col for col in prod_count_cols_raw if col in cust_row.columns]]
                    if not prod_data.empty and prod_data.max() > 0:
                        top_prod_col = prod_data.idxmax()
                        top_prod_name = top_prod_col.replace('_Count', '').replace('_', ' ')
                
                # Top Ship Mode
                top_ship_name = "N/A"
                if any(col in cust_row.columns for col in ship_count_cols_raw):
                    ship_data = cust_data[[col for col in ship_count_cols_raw if col in cust_row.columns]]
                    if not ship_data.empty and ship_data.max() > 0:
                        top_ship_col = ship_data.idxmax()
                        top_ship_name = top_ship_col.replace('_Count', '').replace('_', ' ')

                # Top Sub-Categories (Ambil dari data transaksi mentah)
                customer_transactions = data[data['Customer ID'] == customer_id]
                top_sub_categories = customer_transactions['Sub-Category'].value_counts().nlargest(3)
                top_purchase_name = "N/A"
                if not top_sub_categories.empty:
                    top_items = top_sub_categories.index.tolist()
                    top_purchase_name = ", ".join(top_items) 
                
                # 4. Tampilkan 4 Card Metrik Teratas (FIXED STYLING)
                
                c_card1, c_card2, c_card3, c_card4 = st.columns(4)

                with c_card1:
                    # Top Product Type
                    components.html(top_feature_card("Top Product Type", top_prod_name), height=130)

                with c_card2:
                    # Top Ship Mode
                    components.html(top_feature_card("Top Ship Mode", top_ship_name), height=130)

                with c_card3:
                    # Top Sub-Categories
                    components.html(top_feature_card("Top Sub-Categories", top_purchase_name), height=130)

                with c_card4:
                    # Total Spend (Monetary) - FIX: Card Ungu
                    components.html(top_feature_card("Total Spend (Monetary)", f"${cust_monetary:,.0f}", is_accent=True), height=130)
                    
                st.markdown("<div style='height: 30px;'></div>", unsafe_allow_html=True)
                
                # Opsi: Tampilkan Transaksi Terakhir (opsional)
                if not customer_transactions.empty:
                    st.markdown(f"<h4>Last 5 Transactions for <b>{customer_id}</b></h4>", unsafe_allow_html=True)
                    st.dataframe(customer_transactions.sort_values('Order Date', ascending=False).head(5), use_container_width=True)
                

def show_customer_detection_page():
    st.markdown(f"<h1 style='font-size: 40px; font-weight: bold; color: {TEXT_COLOR}; font-family: \"Source Sans Pro\", sans-serif;'>🔍 Customer Detection (RFM Model)</h1>", unsafe_allow_html=True)
    st.markdown("<p>Masukkan nilai Recency, Frequency, dan Monetary untuk memprediksi segmentasi pelanggan dan mendapatkan rekomendasi produk.</p>", unsafe_allow_html=True)
    
    st.markdown("---")

    c1, c2, c3 = st.columns(3)
    with c1:
        # Min/Max values are rough estimates for input usability
        recency = st.number_input("Recency (Hari sejak pembelian terakhir)", min_value=1, max_value=750, value=90)
    with c2:
        frequency = st.number_input("Frequency (Jumlah order)", min_value=1, max_value=20, value=3)
    with c3:
        monetary = st.number_input("Monetary (Total pengeluaran $)", min_value=100, max_value=10000, value=1500)

    # Tambahkan jarak di sini (misalnya, dua baris kosong)
    st.markdown("<br><br>", unsafe_allow_html=True)

    if st.button("Predict Segment"):
        predicted_cluster = predict_segment(recency, frequency, monetary)
        segment_info = CLUSTER_MAPPING.get(predicted_cluster, CLUSTER_MAPPING[1])
        
        st.markdown("<div style='height: 30px;'></div>", unsafe_allow_html=True)
        st.markdown(f"<h2 style='color:{ACCENT_COLOR}'>Predicted Segment: {segment_info['name']}</h2>", unsafe_allow_html=True)
        
        st.markdown("---")

        col_left, col_right = st.columns(2)
        with col_left:
            st.markdown(f"<h3>🎯 Target Strategi</h3>", unsafe_allow_html=True)
            if predicted_cluster == 2:
                st.success("Tujuan: Retensi & Program Loyalitas Eksklusif.")
            elif predicted_cluster == 0:
                st.info("Tujuan: Peningkatan Frekuensi Pembelian (Up-selling/Cross-selling).")
            else:
                st.warning("Tujuan: Reaktivasi (Win-back campaigns) & Pencegahan Churn.")

        with col_right:
            st.markdown(f"<h3>🎁 Rekomendasi Produk</h3>", unsafe_allow_html=True)
            st.markdown(f"""
                <div class="card-container" style="background-color: #F8F9FA; padding: 15px;">
                <p style='color: {TEXT_COLOR}; font-size: 16px; font-weight: 600;'>Berdasarkan karakteristik {segment_info['name'].split()[0]}:</p>
                <ul>
                    {chr(10).join([f"<li style='color: {TEXT_COLOR};'> {item}</li>" for item in segment_info['reco']])}
                </ul>
                </div>
            """, unsafe_allow_html=True)


# --- SIDEBAR ---
st.sidebar.markdown("""
    <style>
    /* Styling for the bottom logo container to fix it to the bottom */
    .bottom-logo-container {
        position: fixed;
        bottom: 20px;
        left: 20px; /* Adjust based on sidebar width */
        width: 180px; /* Width must be fixed or relative to sidebar width */
        text-align: left;
        z-index: 1; /* Ensure it stays above other elements */
        padding: 0 10px;
    }
    
    /* Adjust sidebar padding to accommodate fixed element */
    [data-testid="stSidebarContent"] {
        padding-bottom: 120px; /* Ensure space for the fixed logo */
    }
    </style>
""", unsafe_allow_html=True)

# 1. Logo Top (di atas Navigasi Dashboard)
# Mengganti use_column_width=True dengan width=300 (untuk menghilangkan warning)
try:
    # Menggunakan width karena use_column_width deprecated
    st.sidebar.image("logo_top.png", width=300) 
except FileNotFoundError:
    st.sidebar.markdown('<p style="color:white; font-size: 18px; font-weight: bold; text-align: center;">[LOGO DASHBOARD PLACEHOLDER]</p>', unsafe_allow_html=True)


st.sidebar.title("Navigasi Dashboard")
p = st.sidebar.radio("Navigasi", ["Overview", "Customer Segmentation", "Customer Detection (Model)"], label_visibility="collapsed")
# Menghapus st.sidebar.caption(f"Data: {min(all_years)} - {max(all_years)}") sesuai permintaan.

# 2. Logo Bottom (di pojok kiri bawah)
st.sidebar.markdown("<div class='bottom-logo-container'>", unsafe_allow_html=True)
# Asumsi file logo_tim.png ada di direktori yang sama
try:
    st.sidebar.image("logo_tim.png", width=100) # Sesuaikan width sesuai kebutuhan
except FileNotFoundError:
    st.sidebar.markdown('<p style="color:rgba(255, 255, 255, 0.5); font-size: 12px; margin-top: 10px;">Powered by [Team Logo Placeholder]</p>', unsafe_allow_html=True)

st.sidebar.markdown("</div>", unsafe_allow_html=True)


if p == "Overview": show_overview_page(data, all_years)
elif p == "Customer Segmentation": show_segmentation_page()

else: show_customer_detection_page()



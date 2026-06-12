"""Streamlit demo for AIO2025 interpolation tutorial.

Run with:
    uv pip install streamlit pandas matplotlib
    streamlit run streamlit_app.py
"""
import io

import matplotlib.pyplot as plt
import pandas as pd
import streamlit as st


def nearest_interpolation(data_list):
    interpolated_list = data_list[:]
    for i in range(len(interpolated_list)):
        if pd.isna(interpolated_list[i]):
            left_distance = right_distance = float("inf")
            left_value = right_value = None
            for j in range(i - 1, -1, -1):
                if not pd.isna(interpolated_list[j]):
                    left_value = interpolated_list[j]
                    left_distance = i - j
                    break
            for j in range(i + 1, len(interpolated_list)):
                if not pd.isna(interpolated_list[j]):
                    right_value = interpolated_list[j]
                    right_distance = j - i
                    break
            if left_distance <= right_distance:
                interpolated_list[i] = left_value
            else:
                interpolated_list[i] = right_value
    return interpolated_list


def linear_interpolation(data_list):
    interpolated_list = data_list[:]
    nan_indices = [i for i, x in enumerate(interpolated_list) if pd.isna(x)]
    for i in nan_indices:
        prev_index, prev_val = -1, None
        for j in range(i - 1, -1, -1):
            if not pd.isna(interpolated_list[j]):
                prev_index, prev_val = j, interpolated_list[j]
                break
        next_index, next_val = -1, None
        for j in range(i + 1, len(interpolated_list)):
            if not pd.isna(interpolated_list[j]):
                next_index, next_val = j, interpolated_list[j]
                break
        if prev_index != -1 and next_index != -1:
            x1, y1 = prev_index, prev_val
            x2, y2 = next_index, next_val
            interpolated_list[i] = y1 + (y2 - y1) * (i - x1) / (x2 - x1)
        elif prev_index != -1:
            interpolated_list[i] = prev_val
        elif next_index != -1:
            interpolated_list[i] = next_val
    return interpolated_list


def average_interpolation(data_list):
    interpolated_list = data_list[:]
    nan_indices = [i for i, x in enumerate(interpolated_list) if pd.isna(x)]
    for i in nan_indices:
        prev_val = next_val = None
        if i > 0 and not pd.isna(interpolated_list[i - 1]):
            prev_val = interpolated_list[i - 1]
        if i < len(interpolated_list) - 1 and not pd.isna(interpolated_list[i + 1]):
            next_val = interpolated_list[i + 1]
        if prev_val is not None and next_val is not None:
            interpolated_list[i] = (prev_val + next_val) / 2
        elif prev_val is not None:
            interpolated_list[i] = prev_val
        elif next_val is not None:
            interpolated_list[i] = next_val
    return interpolated_list


METHODS = {
    "Nearest Neighbor": nearest_interpolation,
    "Linear": linear_interpolation,
    "Average": average_interpolation,
}


st.set_page_config(page_title="Ứng dụng nội suy dữ liệu nhiệt độ", layout="wide")
st.title("Ứng dụng nội suy dữ liệu nhiệt độ")
st.caption(
    "Ứng dụng này giúp xử lý dữ liệu nhiệt độ bị thiếu và so sánh các phương pháp nội suy."
)

method_choice = st.selectbox(
    "Các bước thực hiện",
    list(METHODS.keys()) + ["So sánh tất cả"],
)

uploaded = st.file_uploader("Chọn file CSV chứa dữ liệu nhiệt độ", type=["csv"])

if uploaded is not None:
    df = pd.read_csv(uploaded, skip_blank_lines=False)
    if "temperature" not in df.columns:
        st.error("CSV must have a 'temperature' column.")
        st.stop()

    data_list = df["temperature"].tolist()

    st.subheader("Dữ liệu gốc (đã tải lên)")
    fig_raw, ax_raw = plt.subplots(figsize=(10, 3))
    ax_raw.plot(range(len(data_list)), data_list, marker="o")
    ax_raw.set_xlabel("Index")
    ax_raw.set_ylabel("Temperature")
    ax_raw.grid(alpha=0.3)
    st.pyplot(fig_raw)

    st.subheader("Kết quả nội suy")

    if method_choice == "So sánh tất cả":
        results = {name: fn(data_list) for name, fn in METHODS.items()}
        comp_df = pd.DataFrame({"original": data_list, **results})
        st.dataframe(comp_df, use_container_width=True)

        fig, ax = plt.subplots(figsize=(10, 4))
        x = list(range(len(data_list)))
        for name, vals in results.items():
            ax.plot(x, vals, marker="o", label=name, alpha=0.8)
        for mi, v in enumerate(data_list):
            if pd.isna(v):
                ax.axvline(mi, color="red", alpha=0.15, linewidth=8)
        ax.set_xlabel("Index")
        ax.set_ylabel("Temperature")
        ax.legend()
        ax.grid(alpha=0.3)
        st.pyplot(fig)
    else:
        result = METHODS[method_choice](data_list)
        out_df = pd.DataFrame({"original": data_list, method_choice: result})
        st.dataframe(out_df, use_container_width=True)

        fig, ax = plt.subplots(figsize=(10, 4))
        x = list(range(len(data_list)))
        ax.plot(x, result, marker="o", label=method_choice)
        for mi, v in enumerate(data_list):
            if pd.isna(v):
                ax.axvline(mi, color="red", alpha=0.15, linewidth=8)
        ax.set_xlabel("Index")
        ax.set_ylabel("Temperature")
        ax.legend()
        ax.grid(alpha=0.3)
        st.pyplot(fig)

        buf = io.StringIO()
        out_df.to_csv(buf, index=False)
        st.download_button(
            "Tải xuống kết quả CSV",
            buf.getvalue(),
            file_name=f"interpolated_{method_choice.lower().replace(' ', '_')}.csv",
            mime="text/csv",
        )
else:
    st.info("Hãy tải lên file CSV có cột 'temperature'.")

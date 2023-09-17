import tkinter as tk
from tkinter import filedialog, dialog, StringVar, IntVar
from tkinter.filedialog import askdirectory
from tkinter import ttk
from audio2mouth import *
import os
import sys
import webbrowser

# 全局变量
wav_path=''

# 自动创建输出文件夹
def is_output_path_exist():
    if not os.path.exists('.\Output_file'):
        os.mkdir('.\Output_file')
is_output_path_exist()

# 根据选择设置默认系数
def set_default_factor(event):
    # if 列表.get() == "fun model":
    #     趣味模式.place(relx=0.32, rely=0.7)
    #     return 
    # else:
    #     趣味模式.place_forget()
    default_dist = {"(mi)texture model": 0.16,"(mi)curve model": 0.45,"bbmodel": 1}
    factor_var.set(default_dist[列表.get()])

# GUI
window = tk.Tk()
link = tk.Label(window, text='Tutorial', font=('Arial', 10),fg = 'blue')
link2 = tk.Label(window, text='使用教程', font=('Arial', 10),fg = 'blue')
def open_url(event):
    global link
    link.isclick=True
    webbrowser.open("https://www.youtube.com/watch?v=kgjpyFUZUeY", new=0)
def open_url2(event):
    global link2
    link2.isclick=True
    webbrowser.open("https://www.bilibili.com/video/BV1qx411i7Wu?p=2", new=0)

def changecolor(event):
    global link,link2
    link['fg']='#D52BC4'#鼠标进入，改变为紫色
    link['cursor']='hand2'
def changecolor2(event):
    global link,link2
    link2['fg']='#D52BC4'#鼠标进入，改变为紫色
    link2['cursor']='hand2'

def changecurcor(event):
    global link,link2
    if link.isclick==False:#如果链接未被点击，显示会蓝色
        link['fg']='blue'
    link['cursor']='xterm'
    if link2.isclick==False:#如果链接未被点击，显示会蓝色
        link2['fg']='blue'
    link2['cursor']='xterm'
def load_wav():
    global wav_path
    filename = filedialog.askopenfilename(initialdir ='.\\',title=r"Select your audio file(format is .wav)", filetypes=[('Audio','.wav')])
    wav_path = filename
    state_var.set('Audio loaded')
def GUI_main():
    global link2,link,window,state_var,列表,factor_var,factor_Spinbox,factor_Spinbox2,initx_Spinbox,inity_Spinbox
    link.isclick=False#未被点击
    link2.isclick=False#未被点击
    window.title('Mouth-Animator(English version)')
    window.geometry('450x600+460+260')

    # author = tk.Label(window,text='Authors:\nExcitablecell\nStanwade\nttrtty5',font=14,width=1,height=1,justify="left").place(relx=-0.275, rely=-0.35, relheight=2.25, relwidth=0.889)
    # author = tk.Label(window,text='作者:\n亢体动画\n瓦斯弹\nttrtty5',font=14,width=1,height=1,justify="left").place(relx=-0.32, rely=-0.35, relheight=2.25, relwidth=0.889)
    l = tk.Label(window,text=r"Select your audio file(format is .wav)",font=('Arial', 15),width=30,height=2).place(relx=0.1, rely=0.05, relheight=0.1, relwidth=0.889)

    # 运行状态标签
    state_var = StringVar()
    state_label = tk.Label(window,textvariable=state_var,font=('Arial', 15),width=30,height=2).place(relx=0.03, rely=0.6, relheight=0.1, relwidth=0.889)
    
    b = tk.Button(window,text ="Select audio", font=('Arial', 15),command = load_wav).place(relx=0.35, rely=0.19, relheight=0.09, relwidth=0.3)

    # 调整系数
    factor_var2 = IntVar()
    factor_var2.set(1)
    tk.Label(window,text='scale_x: ',font=('Arial', 12),width=18,height=2).place(relx=0.45, rely=0.3, relheight=0.1, relwidth=0.3)
    # ,textvariable=factor_var
    factor_Spinbox2 = tk.Spinbox(window,from_=0.01,to_=10,format='%10.2f',increment=0.1,textvariable=factor_var2)
    factor_Spinbox2.place(relx=0.7, rely=0.325, relheight=0.05, relwidth=0.15)

    # 调整系数
    factor_var = IntVar()
    factor_var.set(1)
    tk.Label(window,text='scale_y: ',font=('Arial', 12),width=18,height=2).place(relx=0.45, rely=0.4, relheight=0.1, relwidth=0.3)
    # ,textvariable=factor_var
    factor_Spinbox = tk.Spinbox(window,from_=0.01,to_=10,format='%10.2f',increment=0.1,textvariable=factor_var)
    factor_Spinbox.place(relx=0.7, rely=0.425, relheight=0.05, relwidth=0.15)

    # 调整系数
    initx_var = IntVar()
    initx_var.set(0.75)
    tk.Label(window,text='init_x: ',font=('Arial', 12),width=18,height=2).place(relx=0.1, rely=0.3, relheight=0.1, relwidth=0.3)
    # ,textvariable=factor_var
    initx_Spinbox = tk.Spinbox(window,from_=-10,to_=10,format='%10.2f',increment=0.1,textvariable=initx_var)
    initx_Spinbox.place(relx=0.3, rely=0.325, relheight=0.05, relwidth=0.15)

    # 调整系数
    inity_var = IntVar()
    inity_var.set(0.5)
    tk.Label(window,text='init_y: ',font=('Arial', 12),width=18,height=2).place(relx=0.1, rely=0.4, relheight=0.1, relwidth=0.3)
    # ,textvariable=factor_var
    inity_Spinbox = tk.Spinbox(window,from_=-10,to_=10,format='%10.2f',increment=0.1,textvariable=inity_var)
    inity_Spinbox.place(relx=0.3, rely=0.425, relheight=0.05, relwidth=0.15)

    # 嘴型下拉框
    miobj_template = ("(mi)texture model","(mi)curve model","bbmodel")
    列表 = ttk.Combobox(window,font=('Arial', 12))
    列表["values"] = miobj_template
    列表.configure(state = "readonly")
    列表.current(0)
    列表.place(relx=0.27, rely=0.55)
    列表.bind("<<ComboboxSelected>>", set_default_factor)

    tk.Button(window,text ="Output", font=('Arial', 15), command = main).place(relx=0.35, rely=0.7, relheight=0.09, relwidth=0.3)

    link.place(relx=-0.2, rely=0.9, relheight=0.05, relwidth=0.889)
    link.bind("<Button-1>", open_url)
    link.bind("<Leave>", changecurcor)
    link.bind('<Enter>',changecolor)

    link2.place(relx=0.3, rely=0.9, relheight=0.05, relwidth=0.889)
    link2.bind("<Button-1>", open_url2)
    link2.bind("<Leave>", changecurcor)
    link2.bind('<Enter>',changecolor2)
    window.mainloop()

# audio2mouth函数
def main():
    global wav_path,state_var,factor_Spinbox,factor_Spinbox2,initx_Spinbox,inity_Spinbox
    if wav_path=='':
        state_var.set('Audio is not loaded!')
        return 
    
    vol = getVolume(wav_path)
    vol = normalization(vol, 40, float(factor_Spinbox.get()))

    vol2 = getVolume(wav_path)
    vol2 = normalization(vol2, 40, float(factor_Spinbox2.get()))

    time = getTime(wav_path, vol)
    total = len(time)  # 总帧数填到total里
    scale = vol  # 每个尺寸填到scale列表里（覆盖这里面的0-5）

    kind = 列表.get()
    flag = 0
    if kind == '(mi)texture model':

        for k in range(total):
            if vol2[k] < 0.06:
                vol2[k] = 0
            if scale[k] < 0.06:
                scale[k] = 0

        with open(r"miobj_template/texturemouth/template_mouth.miobject", "r")as f:
            MiFileData = f.read()
            MiDict = json.loads(MiFileData)
        num = 0
        for num in range(500):
            if (MiDict['timelines'][num]['name'] == 'mouth'):
                break

        for j in range(total):
            MiDict['timelines'][num]['keyframes'][j + 1] = {
                "SCA_X": float(initx_Spinbox.get()) - vol2[j],
                "SCA_Z": float(inity_Spinbox.get()) + scale[j],
            }
        copyfile("miobj_template/texturemouth/he.png","Output_file/he.png")
        copyfile("miobj_template/texturemouth/h x.png","Output_file/h x.png")
    elif kind == '(mi)curve model':
        with open(r"miobj_template/texturemouth/curvemouth.miobject", "r")as f:
            MiFileData = f.read()
            MiDict = json.loads(MiFileData)
        num = 0
        for num in range(500):
            if (MiDict['timelines'][num]['name'] == 'mouth_control'):
                break

        for j in range(total):
            MiDict['timelines'][num]['keyframes'][j + 1] = {
                "POS_X": 0,
                "POS_Y": 4.00421,
                "POS_Z": 0.72884,
                "SCA_X": float(initx_Spinbox.get()) - vol2[j],
                "SCA_Y": 0.5,
                "SCA_Z": float(inity_Spinbox.get()) + scale[j],
                "RGB_MUL": "#FFD2AA",
                "MIX_COLOR": "#FFC029"
            }
        copyfile("miobj_template/texturemouth/curvemouth.mimodel","Output_file/curvemouth.mimodel")
        copyfile("miobj_template/texturemouth/Default texture.png","Output_file/Default texture.png")
    elif kind == 'bbmodel':
        with open(r"miobj_template/texturemouth/mouth.bbmodel", "r")as f:
            MiFileData = f.read()
            MiDict = json.loads(MiFileData)
        for j in range(total):
            if scale[j] > 0.06:
                flag = 1
                MiDict['animations'][0]['animators']["63a4fddb-d8bb-b96b-cfa5-84158414f3d2"]['keyframes'].append({
                    "channel": "scale",
					["data_points"][0]: [{
						"x": "1",
						"y": str(round(float(inity_Spinbox.get()) + scale[j],2)),
						"z": "1"
					}],
					"uuid": "51c9a826-099f-7615-844c-db35ff0e5d9b",
					"time": j/24,
					"color": -1,
					"interpolation": "linear"
                })
            elif scale[j] <= 0.06 and flag == 1:
                flag = 0
                MiDict['animations'][0]['animators']["63a4fddb-d8bb-b96b-cfa5-84158414f3d2"]['keyframes'].append({
                    "channel": "scale",
					["data_points"][0]: [{
						"x": "1",
						"y": "0",
						"z": "1"
					}],
					"uuid": "51c9a826-099f-7615-844c-db35ff0e5d9b",
					"time": j/24,
					"color": -1,
					"interpolation": "linear"
                })
        copyfile("miobj_template/texturemouth/he.png","Output_file/he.png")
        copyfile("miobj_template/texturemouth/h x.png","Output_file/h x.png")
    else:
        state_var.set("转换失败！convert fail!!!")
    MiJson = json.dumps(MiDict, indent='    ', ensure_ascii=False)  # 字典转json文本
    fn = os.path.split(wav_path)[1]
    if kind == 'bbmodel':
        output_path = r"Output_file/" + "output.bbmodel"
    else:
        output_path = r"Output_file/" + "output.miobject"
    with open(output_path, "w+") as f:  # 新建文件
        f.write(MiJson)  # 文本写入文件
    print("convert complete!!! press any key to exit")
    state_var.set('已输出到'+ output_path)
    # window.destroy()
    # sys.exit()



if __name__ == "__main__":
    GUI_main()







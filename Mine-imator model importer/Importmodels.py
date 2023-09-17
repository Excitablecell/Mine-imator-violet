import json
import os
from time import sleep
import sys
import tkinter as tk
from tkinter import filedialog, dialog, StringVar, IntVar
from tkinter.filedialog import askdirectory
from tkinter import ttk
import webbrowser


import numpy as np
from PIL import Image

filepath = ''
newFilepath = ''
texturepath = ''

# setting
offset = True
a = 1.05
multiplier = 3.75
UVmultiplier = 20
Tex_Scale = 0
Scale = 0
# file variables
filetype = [".json",".mimodel"]
file = os.path.split(filepath)

#default
defaultTexture = "Default texture" # default Inherit texture. Relative file path?
defaultTextureSize = [16,16] # default based on Inherit texture # What does the "texture_size" even do? I don't even know
debug = False

def load(filepath): # Load mimodel and Minecraft json
    global Tex_Scale
    try:
        with open(filepath, "rb") as fileObject:
            data = json.load(fileObject)
            textureIndex = 0
            try: # Exception No "textures" found
                try:
                    texture = '0'
                    # texture = data["textures"]['str(textureIndex)']
                except IndexError:
                    textureIndex+=1
                    texture = data["textures"][str(textureIndex)]
            except KeyError:
                texture = defaultTexture
            try: # Exception No "textures_size" found
                texture_size=data["resolution"]
                Tex_Scale = data["resolution"]["width"]
            # except 1:
            #     texture_size=data["texture_size"]
            except KeyError:
                texture_size= defaultTextureSize

            elements = data["elements"] # Extract "elements"
            return elements, texture, texture_size
    except FileNotFoundError:
        print('File not found. Please recheck your file or directory make sure it\'s in the right path.')


def worldGrid(offset): # offset worldGrid by (8,0,8) because it doesn't make sense for Blockbench for the world origin at the corner of the grid
    pivotOffset = [0,0,0]
    if offset == True:
        pivotOffset = np.multiply([8,0,8],multiplier)
    else:
        pass
    return pivotOffset

def UVLayout(value,*args):
    value = np.round(value*UVmultiplier*args[0]*1.05,decimals=0).tolist()
    return value

def axisPart(axis,angle): #axis Rotation
    if axis == "x":
        rotation = [angle,0,0]
    elif axis == "y":
        rotation = [0,angle,0]
    else:
        rotation = [0,0,angle]
    return rotation

def convertBlock(filepath,offset): 
    global Tex_Scale,Scale
    texture_img = Image.open(texturepath)
    elements, texture, texture_size = load(filepath)
    Scale = round(texture_img.size[0]/Tex_Scale)

    model = file[1].replace(filetype[0],'')
    pivotOffset = worldGrid(offset)
    texture = texturepath.split('/')[1]+".png"

    imageTex = np.array(Image.open(texturepath))
    imageSize = imageTex.shape # Image Size
    imageX = imageSize[0]
    imageY = imageSize[1]
    
    mimodel_json = {
        "name": " Converted by Mineimator Violet",
        "texture": texture,
        "texture_size": [16,16]

    }
    num_cube = 0 # numbers of cube parts
    num_parts = 0 # numbers of parts
    total_parts = 0 # total
    count = 0
    parts = []
    for i,element in enumerate(elements): # Extract "elements" list
        count = count + 1
        part = element
        try: # Exception No "name" found. 
            partName = part["name"]
            if num_parts == 0: 
                partName = partName
            else:
                partName = partName + " " + str(num_parts)
            num_parts+=1
            total_parts+=1
        except KeyError:
            if num_cube == 0:
                partName = "cube"
            else:
                partName = "cube" + " " + str(num_cube)
            num_cube+=1
            total_parts+=1
        else:
            pass
        
        shape = element
        shapeFrom = np.array(shape["from"])
        shapeTo = np.array(shape["to"])
        # shapeFrom = np.array((shape["from"][0]*Scale,shape["from"][1]*Scale,shape["from"][2]*Scale))
        # shapeTo = np.array((shape["to"][0]*Scale,shape["to"][1]*Scale,shape["to"][2]*Scale)) 

        origin = np.array(shape["origin"])
        origin = origin.tolist() # part position base on element origin
        position = np.multiply(origin,-1) # shape position flip base on origin

        try:
            rotation = np.array(shape["rotation"])
        except:
            rotation = np.array([0,0,0])
        rotation = rotation.tolist()
        
        face = shape["faces"]

        faceU = face["up"]["uv"][0]
        faceE = face["east"]["uv"][1]

        h = 0
        w = 0
        h = imageY*0.0035
        w = imageX*0.0035
        
        texturePos=[UVLayout(faceU,h)-10,UVLayout(faceE,w)*1.05-8]

        try:
            faceU = np.array([face["up"]["uv"][0]*Scale,face["up"]["uv"][1]*Scale,face["up"]["uv"][2]*Scale,face["up"]["uv"][3]*Scale])
        except:
            faceU = np.array([0,0,0])
        faceU = faceU.tolist()
        
        if faceU[2] < faceU[0] and faceU[3] < faceU[1]:
            faceU_copy = texture_img.crop((faceU[2],faceU[3],faceU[0],faceU[1]))
        elif faceU[0] < faceU[2] and faceU[3] < faceU[1]:
            faceU_copy = texture_img.crop((faceU[0],faceU[3],faceU[2],faceU[1])) 
        else:
            faceU_copy = texture_img.crop((faceU[2],faceU[3],faceU[0],faceU[1]))

        try:
            faceD = np.array([face["down"]["uv"][0]*Scale,face["down"]["uv"][1]*Scale,face["down"]["uv"][2]*Scale,face["down"]["uv"][3]*Scale])
        except:
            faceD = np.array([0,0,0])
        faceD = faceD.tolist()
        
        if faceD[0] < faceD[2] and faceD[1] < faceD[3]:
            faceD_copy = texture_img.crop((faceD[0],faceD[1],faceD[2],faceD[3]))
        elif faceD[2] < faceD[0] and faceD[1] < faceD[3]:
            faceD_copy = texture_img.crop((faceD[2],faceD[1],faceD[0],faceD[3]))
        else:
            faceD_copy = texture_img.crop((faceD[0],faceD[1],faceD[2],faceD[3]))

        try:
            faceN = np.array([face["north"]["uv"][0]*Scale,face["north"]["uv"][1]*Scale,face["north"]["uv"][2]*Scale,face["north"]["uv"][3]*Scale])
        except:
            faceN = np.array([0,0,0])
        faceN = faceN.tolist()
        
        if faceN[0] < faceN[2] and faceN[1] < faceN[3]:
            faceN_copy = texture_img.crop((faceN[0],faceN[1],faceN[2],faceN[3]))
        elif faceN[2] < faceN[0] and faceN[1] < faceN[3]:
            faceN_copy = texture_img.crop((faceN[2],faceN[1],faceN[0],faceN[3]))
            faceN_copy = faceN_copy.transpose(Image.FLIP_LEFT_RIGHT)
        else:
            faceN_copy = texture_img.crop((faceN[0],faceN[1],faceN[2],faceN[3]))

        try:
            faceS = np.array([face["south"]["uv"][0]*Scale,face["south"]["uv"][1]*Scale,face["south"]["uv"][2]*Scale,face["south"]["uv"][3]*Scale])
        except:
            faceS = np.array([0,0,0])
        faceS = faceS.tolist()

        if faceS[0] < faceS[2] and faceS[1] < faceS[3]:
            faceS_copy = texture_img.crop((faceS[0],faceS[1],faceS[2],faceS[3]))
        elif faceS[2] < faceS[0] and faceS[1] < faceS[3]:
            faceS_copy = texture_img.crop((faceS[2],faceS[1],faceS[0],faceS[3]))
            faceS_copy = faceS_copy.transpose(Image.FLIP_LEFT_RIGHT)
        else:
            faceS_copy = texture_img.crop((faceS[0],faceS[1],faceS[2],faceS[3]))

        try:
            faceW = np.array([face["west"]["uv"][0]*Scale,face["west"]["uv"][1]*Scale,face["west"]["uv"][2]*Scale,face["west"]["uv"][3]*Scale])
        except:
            faceW = np.array([0,0,0])
        faceW = faceW.tolist()

        if faceW[0] < faceW[2] and faceW[1] < faceW[3]:
            faceW_copy = texture_img.crop((faceW[0],faceW[1],faceW[2],faceW[3]))
        elif faceW[2] < faceW[0] and faceW[1] < faceW[3]:
            faceW_copy = texture_img.crop((faceW[2],faceW[1],faceW[0],faceW[3]))
            faceW_copy = faceW_copy.transpose(Image.FLIP_LEFT_RIGHT)
        else:
            faceW_copy = texture_img.crop((faceW[0],faceW[1],faceW[2],faceW[3]))

        try:
            faceE = np.array([face["east"]["uv"][0]*Scale,face["east"]["uv"][1]*Scale,face["east"]["uv"][2]*Scale,face["east"]["uv"][3]*Scale])
        except:
            faceE = np.array([0,0,0])
        faceE = faceE.tolist()

        if faceE[0] < faceE[2] and faceE[1] < faceE[3]:
            faceE_copy = texture_img.crop((faceE[0],faceE[1],faceE[2],faceE[3]))
        elif faceE[2] < faceE[0] and faceE[1] < faceE[3]:
            faceE_copy = texture_img.crop((faceE[2],faceE[1],faceE[0],faceE[3]))
            faceE_copy = faceE_copy.transpose(Image.FLIP_LEFT_RIGHT)
        else:
            faceE_copy = texture_img.crop((faceE[0],faceE[1],faceE[2],faceE[3]))
        
        # texture_new = Image.new('RGBA', (100,100),)
        if (faceW[2]+faceE[2]+faceN[2]+faceS[2]) > 0:
            xsize = round(abs((faceW[2]+faceE[2]+faceN[2]+faceS[2]) - abs(faceW[0]+faceE[0]+faceN[0]+faceS[0])))
            ysize = round(abs(faceW[3] - faceW[1]))+round(abs(faceU[3] - faceU[1]))
            texsize = (xsize,ysize)
            texture_new = Image.new('RGBA',texsize)
        else:
            xsize = round(abs((faceW[2]+faceE[2]+faceN[2]+faceS[2]) - abs(faceW[0]+faceE[0]+faceN[0]+faceS[0]))+1)
            ysize = round(abs(faceW[3] - faceW[1]))+round(abs(faceU[3] - faceU[1]))
            texsize = (xsize,ysize)
            texture_new = Image.new('RGBA',texsize)
        
        texture_new.paste(faceU_copy,(round(abs(faceW[2]-faceW[0])),0))
        texture_new.paste(faceD_copy,(round(abs(faceW[2]-faceW[0])+abs(faceS[2]-faceS[0])),0))
        texture_new.paste(faceW_copy,(0,round(abs(faceU[3]-faceU[1]))))
        texture_new.paste(faceS_copy,(round(abs(faceW[2]-faceW[0])),round(abs(faceU[3]-faceU[1]))))
        texture_new.paste(faceE_copy,(round(abs(faceW[2]-faceW[0])+abs(faceS[2]-faceS[0])),round(abs(faceU[3]-faceU[1]))))
        texture_new.paste(faceN_copy,(round(abs(faceW[2]-faceW[0])+abs(faceS[2]-faceS[0])+abs(faceE[2]-faceE[0])),round(abs(faceU[3]-faceU[1]))))
        texture_new = texture_new.resize((round(xsize*Scale),round(ysize*Scale)),Image.NEAREST)
        texture_new.save(newFilepath + "/" + str(count) + ".png")

        # texture_use = Image.new('RGB',texture_img.size, (255, 255, 255))
        # texture_use.paste(texture_new,uv,0)
        # texture_use.save(newFilepath + "/TEX/" + str(count) + ".png")

        if texture_size["width"] == 32:
            textureScale = 2
        elif texture_size["width"] == 64:
            textureScale = 3
        elif texture_size["width"] == 128:
            textureScale = 4
        else:
            textureScale = 1 # textureScale = 1 #default

        # uv = texturePos
        #convert np list
        shapeFrom =shapeFrom.tolist()
        shapeTo = shapeTo.tolist()
        position = position.tolist()

        shape = []
        shape.append({ 
            "type": "block",
            "description": partName + " shape",
            "texture": str(count) + ".png",
            # "texture_size": texture_size,
            "texture_size": texture_new.size,
            "texture_scale": textureScale, 
            # "color_blend": "#000000",
			# "color_mix": "#FFFFFF",
			# "color_mix_percent": 1,
			# "color_brightness": 0,
            "from": shapeFrom,
            "to": shapeTo,
            # "uv": uv, # TODO: new UV map based on calculation
            # "uv": (abs(faceW[2]-faceW[0])*Scale,abs(faceW[2]-faceW[0])*Scale),
            "uv": (abs(faceW[2]-faceW[0])/Scale,abs(faceW[2]-faceW[0])/Scale),
            "position": position, 
            "rotation" : [0 , 0 , 0 ],
            "scale" : [ 1, 1, 1 ]
        })
        parts.append({
            "name": partName,
            # "color_blend": "#000000",
			# "color_mix": "#FFFFFF",
			# "color_mix_percent": 1,
			# "color_brightness": 0,
            "position": np.subtract(origin,pivotOffset).tolist(),     
            "rotation": rotation, 
            "scale": [ 1, 1, 1 ],
            "shapes": shape
        })
    parentPart = []
    parentPart.append({
        "name": model,
        # "color_blend": "#000000",
        # "color_mix": "#FFFFFF",
        # "color_mix_percent": 1,
        # "color_brightness": 0,
        "position": [ 0, 0, 0 ],     
        # "rotation": [ 0, 0, 0 ], 
        # "scale": [ 1, 1, 1 ],
        "parts": parts
    })

    mimodel_json["parts"] = parentPart
    return mimodel_json
fin_flag = 0
def exportMI():
    global filepath,newFilepath,offset,fin_flag
    newFilepath = r"Output_file/"
    if filepath=='':
        state_var.set('Model is not loaded!')
        return 
    if texturepath=='':
        state_var.set('Texture is not loaded!')
        return
    try:
        path = os.path.split(filepath)[0]+"\\"
        file = os.path.split(filepath)[1].replace(filetype[0],'')
        try:
            mimodel_json = convertBlock(filepath,offset)
        except:
            state_var.set('Convert Failed !')
        if path == newFilepath:
            file = file+"_converted"+filetype[1]
        else:
            file = file+filetype[1]
        # newFilepath = newFilepath+"\\"+file
        newFilepath =  r"Output_file/" + "importmodel.mimodel"
        with open(newFilepath, "w") as f:
            json.dump(mimodel_json, f)
        window.destroy()
        sys.exit()
    except:
        state_var.set('Convert Failed !')

def load_file():
    global filepath
    filename = filedialog.askopenfilename(initialdir ='.\\',title=r"Select your model file(format is .bbmodel)", filetypes=[('Minecraft JAVA Model',('.bbmodel','.j*'),)])
    filepath = filename
    if filename != '\Output_file':
        state_var.set('Model loaded')
    else:
        state_var.set('Please load Model')

def load_texture():
    global texturepath
    texname = filedialog.askopenfilename(initialdir ='.\\',title=r"Select your texture file(format is .png)", filetypes=[('Texture','.png')])
    texturepath = texname
    if texname != '':
        state_var.set('Texture loaded')
    else:
        state_var.set('Please load Texture')

# 自动创建输出文件夹
def is_output_path_exist():
    if not os.path.exists('.\Output_file'):
        os.mkdir('.\Output_file')
is_output_path_exist()

def exp_lib():
    global newFilepath
    # foldername = filedialog.askdirectory(title=r"Select your target folder")
    foldername = rb"/Output_file/"
    newFilepath = foldername
    if foldername != '':
        state_var.set('folder selected')
    else:
        state_var.set('Please select folder')

def open_url(event):
    global link
    link.isclick=True
    webbrowser.open("https://youtu.be/VenmIAzMudY", new=0)

def changecolor(event):
    global link
    link['fg']='#D52BC4'#鼠标进入，改变为紫色
    link['cursor']='hand2'

def changecurcor(event):
    global link
    if link.isclick==False:#如果链接未被点击，显示会蓝色
        link['fg']='blue'
    link['cursor']='xterm'

def open_url2(event):
    global link2
    link2.isclick=True
    webbrowser.open("https://www.bilibili.com/video/BV1qx411i7Wu?p=4", new=0)

def changecolor2(event):
    global link2
    link2['fg']='#D52BC4'#鼠标进入，改变为紫色
    link2['cursor']='hand2'

def changecurcor2(event):
    global link2
    if link2.isclick==False:#如果链接未被点击，显示会蓝色
        link2['fg']='blue'
    link2['cursor']='xterm'

window = tk.Tk()
link = tk.Label(window, text='Tutorial', font=('Arial', 10),fg = 'blue')
link2 = tk.Label(window, text='使用教程', font=('Arial', 10),fg = 'blue')
def GUI_main():
    global state_var,link,fin_flag,link2
    link.isclick=False#未被点击
    link2.isclick=False#未被点击
    window.title(r"Import from Resource Pack(亢体动画)")
    window.geometry('400x600+800+200')
    state_var = StringVar()
    tk.Label(window,text=rb"FROM (.bbmodel/.json)  TO  (.mimodel)",font=('Arial', 12),width=1,height=1,justify="left").place(relx=0.07, rely=0.1, relheight=0.1, relwidth=0.889)
    tk.Label(window,textvariable=state_var,font=('Arial', 20),width=30,height=3).place(relx=0.035, rely=0.6, relheight=0.1, relwidth=0.889)
    tk.Button(window,text ="1.Select Model", font=('Arial', 14),command = load_file).place(relx=0.2, rely=0.19, relheight=0.09, relwidth=0.6)
    tk.Button(window,text ="2.Select Texture", font=('Arial', 14),command = load_texture).place(relx=0.2, rely=0.29, relheight=0.09, relwidth=0.6)
    # tk.Button(window,text ="3.Select Export Folder", font=('Arial', 14),command = exp_lib).place(relx=0.2, rely=0.39, relheight=0.09, relwidth=0.6)
    tk.Button(window,text ="4.output", font=('Arial', 14), command = exportMI).place(relx=0.2, rely=0.8, relheight=0.09, relwidth=0.6)
    
    # link = tk.Label(window, text='Tutorial（使用教程）', font=('Arial', 10))
    link.place(relx=-0.3, rely=0.9, relheight=0.05, relwidth=0.889)
    link.bind("<Button-1>", open_url)
    link.bind("<Leave>", changecurcor)
    link.bind('<Enter>',changecolor)

    link2.place(relx=0.4, rely=0.9, relheight=0.05, relwidth=0.889)
    link2.bind("<Button-1>", open_url2)
    link2.bind("<Leave>", changecurcor2)
    link2.bind('<Enter>',changecolor2)
    window.mainloop()
    # exportMI()

if __name__ == "__main__":
    GUI_main()
    

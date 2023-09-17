import json
import math
import numpy as np
import wave
from shutil import copyfile


def calVolume(waveData, frameSize):
    wlen = len(waveData)
    print('wlen', wlen)
    step = frameSize
    frameNum = int(math.ceil(wlen * 1.0 / step))
    print('frameNum', frameNum)
    volume = np.zeros((frameNum, 1))
    for i in range(frameNum):
        curFrame = waveData[np.arange(i * step, min(i * step + frameSize, wlen))]
        curFrame = curFrame - np.median(curFrame)  # zero-justified
        volume[i] = np.sum(np.abs(curFrame))
    return volume


def getVolume(filePath):
    fw = wave.open(filePath, 'rb')  
    params = fw.getparams()
    nchannels, sampwidth, framerate, nframes = params[:4]
    print(params)
    strData = fw.readframes(nframes)
    waveData = np.frombuffer(strData, dtype=np.int16)
    waveData = waveData * 1.0 / max(abs(waveData))
    fw.close()
    frameSize = int(framerate / 24) * nchannels + 1
    print('framesize', frameSize)
    volume = calVolume(waveData, frameSize)
    return volume[:, 0]


def getTime(filePath, volume11):
    fw = wave.open(filePath, 'rb')
    params = fw.getparams()
    nchannels, sampwidth, framerate, nframes = params[:4]
    fw.close()
    frameSize = 0 + int(framerate / 24)
    time = np.arange(0, len(volume11)) * (frameSize) * 1.0 / framerate
    return time


def normalization(volume11, zero, factor=0.16):  # add a new param called factor, 用来调整影响程度
    volume11 = volume11 - zero
    for i in range(len(volume11)):
        if volume11[i] <= 0.01:
            volume11[i] = 0.001
        # volume11[i] = pow(volume11[i],0.5)
        volume11[i] /= max(volume11)
        volume11[i] *= factor
    return volume11
# 自动创建输出文件夹
def is_output_path_exist():
    if not os.path.exists('.\output_file'):
        os.mkdir('.\output_file')

def main():
    print("Audio converter for mineimator")
    print('\nMine-imator 音频-口型转换器')
    print("\nThis converter is made by EXanimation, Stanwade, ttrtty5 and Chenny Wang")  # fixed some spelling mistakes
    print('\n由亢体、瓦斯弹、ttrtty、干二大日天倾♂情奉献')
    print(
        "\nyou need to put your audio file in the 'audio_resources' folder,and import the finish.miobject into your project after converting")
    print('\n将音频文件(*.wav)放入audio_resources文件夹，操作结束后将finish.miobject导入Mine-imator')
    print("\nplease enter your audio file's name(format is wav):")
    inputFileName = input("请输入需要采集的音频源名称(wav格式，无需输入后缀)：")
    factor = 0.16
    print('\nPlease input factor(default 0.16): ')
    factor = float(input('请输入调整系数(默认为0.16): '))

    vol = getVolume('audio_resources/' + inputFileName + '.wav')
    vol = normalization(vol, 40, factor)
    time = getTime('audio_resources/' + inputFileName + '.wav', vol)
    totalFrame = len(time)  # 总帧数填到totalFrame里
    scale = vol  # 每个尺寸填到scale列表里（覆盖这里面的0-5）

    print(
        "\nPlease select the corresponding number according to your mouth style.(1: texture mouth; 2: curve mouth; 3: Fun mode)")
    kind = int(input("请用数字选择嘴巴模型的类型（1：贴图嘴，2：日天尖嘴, 3：趣味模式)："))

    is_output_path_exist()
    if kind == 1: # 贴图嘴
        with open(r"miobj_template/texturemouth/template_mouth.miobject", "r")as f:
            MiFileData = f.read()
        MiDict = json.loads(MiFileData)
        num = 0
        for num in range(500):
            if (MiDict['timelines'][num]['name'] == 'mouth'):
                break

        for j in range(totalFrame):
            MiDict['timelines'][num]['keyframes'][j + 1] = {
                "SCA_X": 0.09,
                "SCA_Z": scale[j],
            }
        copyfile("miobj_template/texturemouth/he.png", "output_file/he.png")

    elif kind == 2: # 日天嘴
        with open(r"miobj_template/curvemouth/curvemouth.miobject", "r")as f:
            MiFileData = f.read()
        MiDict = json.loads(MiFileData)
        num = 0
        for num in range(500):
            if (MiDict['timelines'][num]['name'] == 'mouth_control'):
                break

        for j in range(totalFrame):
            scale[j] *= 4
            MiDict['timelines'][num]['keyframes'][j + 1] = {
                "POS_X": 0,
                "POS_Y": 4.00421,
                "POS_Z": 0.72884,
                "SCA_X": 0.375,
                "SCA_Y": 0.5,
                "SCA_Z": scale[j],
                "RGB_MUL": "#FFD2AA",
                "MIX_COLOR": "#FFC029"
            }
        copyfile("miobj_template/curvemouth/curvemouth.mimodel", "output_file/curvemouth.mimodel")
        copyfile("miobj_template/curvemouth/Default texture.png", "output_file/Default texture.png")

    elif kind == 3: # 自♂由模式，将响度映射到其它变量上去，设置了6个默认值，同时也支持手动输入，例如输入BEND_ANGLE_X
        print('操作比较复杂，建议查看说明书')
        with open(r"miobj_template/funmodel/fun_template.miobject", "r")as f:
            MiFileData = f.read()
        MiDict = json.loads(MiFileData)
        num = 0
        for num in range(500):
            if (MiDict['timelines'][num]['name'] == 'funmodel'):
                break
        varName = input('想要修改的内容：(1.X尺寸 2.y尺寸 3.z尺寸 4.x旋转 5.y旋转 6. z旋转 7.自己输入)')
        if varName == '1':
            varName = 'SCA_X'
        elif varName == '2':
            varName = 'SCA_Y'
        elif varName == '3':
            varName = 'SCA_Z'
        elif varName == '4':
            varName = 'ROT_X'
        elif varName == '5':
            varName = 'ROT_Y'
        elif varName == '6':
            varName = 'ROT_Z'
        else:
            varName = input('输入变量名：')
        for j in range(totalFrame):
            MiDict['timelines'][num]['keyframes'][j + 1] = {
                varName: scale[j]
            }

    else:
        print('转换失败，请填入正确序号！')
        print("we dont have this kind of mouth model!!!")
        print("convert fail!!!")
        input()
    MiJson = json.dumps(MiDict, indent='    ', ensure_ascii=False)  # 字典转json文本
    with open(r"output_file/" + "output.miobject", "w+") as f:  # 新建文件
        f.write(MiJson)  # 文本写入文件
    print("convert complete!!! press any key to exit")
    input()

if __name__ == "__main__":
    main()
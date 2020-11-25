##前言

气泡框作为社交聊天软件的基本功能，想必大家都了解怎么实现了。但是像国内巨头腾讯旗下的QQ气泡(尤其是动态的)我想应该是没有几个。这里就为大家提供一种类似QQ动态气泡的解决方案(还不完善)。

首先用到了一个第三方[Lottie](https://airbnb.io/lottie/), airbnb做的一个专门做动画的东西。专门研究过动画的应该都知道或了解。简单讲就是通过插件将AE中画的动画转换成json文件，然后按照特定规则转换到页面上通过CABaseAnimation来实现。

####明确需求

 - 基本的聊天气泡，随文本大小变更气泡大小并保证边界圆角等形状不变
 - 动态气泡，气泡内容会能动态展示，并根据文本大小，部分动画(如位移)会有区别

#### lottie分析

一下是一段lottie的json文件，部分删减，源文件可在demo中查看，这里标注上重要字段

```json
{
    "v": "5.1.10",
    "fr": 25,
    "ip": 0,
    "op": 750,
    "w": 128,//画布宽
    "h": 72,//画布高
    "nm": "合成 1",
    "ddd": 0,
    "assets": [//使用的图片资源
        {
            "id": "image_0",
            "w": 26,
            "h": 19,
            "u": "images/",
            "p": "data:image/png;base64,"//图片内容，愿框架不支持网络地址，仅能检索本地文件与base64编码后的内容
        }
    ],
    "layers": [//layer层
        {
            "ddd": 0,
            "ind": 1,
            "ty": 2,
            "nm": "星星.png",
            "cl": "png",
            "refId": "image_0",//使用图片资源id
            "sr": 1,
            "ks": {//位置，大小，缩放等信息
                "o": {
                    "a": 0,
                    "k": 100,
                    "ix": 11
                },
                "r": {
                    "a": 0,
                    "k": 0,
                    "ix": 10
                },
                "p": {
                    "a": 1,
                    "k": [
                        {//数组表示核心桢时的位置
                            "i": {
                                "x": 0.833,
                                "y": 0.833
                            },
                            "o": {
                                "x": 0.167,
                                "y": 0.167
                            },
                            "n": "0p833_0p833_0p167_0p167",
                            "t": 0,
                            "s": [//大小
                                21.375,
                                49.125,
                                0
                            ],
                            "e": [//点位
                                20.5,
                                48.375,
                                0
                            ],
                            "to": [//点位
                                -0.14583332836628,
                                -0.125,
                                0
                            ],
                            "ti": [
                                0.14583332836628,
                                0.25,
                                0
                            ]
                        },
                        {
                            "i": {
                                "x": 0.833,
                                "y": 0.833
                            },
                            "o": {
                                "x": 0.167,
                                "y": 0.167
                            },
                            "n": "0p833_0p833_0p167_0p167",
                            "t": 8,
                            "s": [
                                20.5,
                                48.375,
                                0
                            ],
                            "e": [
                                20.5,
                                47.625,
                                0
                            ],
                            "to": [
                                -0.14583332836628,
                                -0.25,
                                0
                            ],
                            "ti": [
                                0,
                                0.14583332836628,
                                0
                            ]
                        },
                        {
                            "t": 185
                        }
                    ],
                    "ix": 2
                },
                "a": {
                    "a": 0,
                    "k": [
                        13,
                        9.5,
                        0
                    ],
                    "ix": 1
                },
                "s": {
                    "a": 1,
                    "k": [
                        {//数组表示核心桢时的大小
                            "i": {
                                "x": [
                                    0.833,
                                    0.833,
                                    0.833
                                ],
                                "y": [
                                    0.833,
                                    0.833,
                                    0.833
                                ]
                            },
                            "o": {
                                "x": [
                                    0.167,
                                    0.167,
                                    0.167
                                ],
                                "y": [
                                    0.167,
                                    0.167,
                                    0.167
                                ]
                            },
                            "n": [
                                "0p833_0p833_0p167_0p167",
                                "0p833_0p833_0p167_0p167",
                                "0p833_0p833_0p167_0p167"
                            ],
                            "t": 19,
                            "s": [
                                71.154,
                                78.947,
                                100
                            ],
                            "e": [
                                61.538,
                                76.316,
                                100
                            ]
                        },
                        {
                            "i": {
                                "x": [
                                    0.833,
                                    0.833,
                                    0.833
                                ],
                                "y": [
                                    0.833,
                                    0.833,
                                    0.833
                                ]
                            },
                            "o": {
                                "x": [
                                    0.167,
                                    0.167,
                                    0.167
                                ],
                                "y": [
                                    0.167,
                                    0.167,
                                    0.167
                                ]
                            },
                            "n": [
                                "0p833_0p833_0p167_0p167",
                                "0p833_0p833_0p167_0p167",
                                "0p833_0p833_0p167_0p167"
                            ],
                            "t": 42,
                            "s": [
                                61.538,
                                76.316,
                                100
                            ],
                            "e": [
                                79.808,
                                78.947,
                                100
                            ]
                        },
                        {
                            "t": 66
                        }
                    ],
                    "ix": 6
                }
            },
            "ao": 0,
            "ip": 0,
            "op": 750,
            "st": 0,
            "bm": 0
        },
		 {
            "ddd": 0,
            "ind": 4,
            "ty": 4,
            "nm": "右下角",
            "sr": 1,
            "ks": {
                "o": {
                    "a": 0,
                    "k": 100,
                    "ix": 11
                },
                "r": {
                    "a": 0,
                    "k": 0,
                    "ix": 10
                },
                "p": {//图层位置
                    "a": 0,
                    "k": [
                        141.25,
                        55.875,
                        0
                    ],
                    "ix": 2
                },
                "a": {
                    "a": 0,
                    "k": [
                        0,
                        0,
                        0
                    ],
                    "ix": 1
                },
                "s": {
                    "a": 0,
                    "k": [
                        100,
                        100,
                        100
                    ],
                    "ix": 6
                }
            },
            "ao": 0,
            "shapes": [//子层数组
                {
                    "ty": "gr",
                    "it": [
                        {
                            "ty": "rc",
                            "d": 1,
                            "s": {//大小
                                "a": 0,
                                "k": [
                                    24.875,
                                    16.125
                                ],
                                "ix": 2
                            },
                            "p": {//位置
                                "a": 0,
                                "k": [
                                    0,
                                    0
                                ],
                                "ix": 3
                            },
                            "r": {
                                "a": 0,
                                "k": 20,
                                "ix": 4
                            },
                            "nm": "矩形路径 1",
                            "mn": "ADBE Vector Shape - Rect",
                            "hd": false
                        },
                        {
                            "ty": "st",
                            "c": {//颜色
                                "a": 0,
                                "k": [
                                    0.901176542394,
                                    0.699030438591,
                                    0.699030438591,
                                    1
                                ],
                                "ix": 3
                            },
                            "o": {
                                "a": 0,
                                "k": 100,
                                "ix": 4
                            },
                            "w": {
                                "a": 0,
                                "k": 0,
                                "ix": 5
                            },
                            "lc": 1,
                            "lj": 1,
                            "ml": 4,
                            "nm": "描边 1",
                            "mn": "ADBE Vector Graphic - Stroke",
                            "hd": false
                        },
                        {
                            "ty": "fl",
                            "c": {
                                "a": 0,
                                "k": [
                                    0.878431432387,
                                    0.760784373564,
                                    0.301960784314,
                                    1
                                ],
                                "ix": 4
                            },
                            "o": {
                                "a": 0,
                                "k": 100,
                                "ix": 5
                            },
                            "r": 1,
                            "nm": "填充 1",
                            "mn": "ADBE Vector Graphic - Fill",
                            "hd": false
                        },
                        {
                            "ty": "tr",
                            "p": {
                                "a": 0,
                                "k": [
                                    -38.562,
                                    -9.438
                                ],
                                "ix": 2
                            },
                            "a": {
                                "a": 0,
                                "k": [
                                    0,
                                    0
                                ],
                                "ix": 1
                            },
                            "s": {
                                "a": 0,
                                "k": [
                                    100,
                                    100
                                ],
                                "ix": 3
                            },
                            "r": {
                                "a": 0,
                                "k": 0,
                                "ix": 6
                            },
                            "o": {
                                "a": 0,
                                "k": 100,
                                "ix": 7
                            },
                            "sk": {
                                "a": 0,
                                "k": 0,
                                "ix": 4
                            },
                            "sa": {
                                "a": 0,
                                "k": 0,
                                "ix": 5
                            },
                            "nm": "变换"
                        }
                    ],
                    "nm": "矩形 1",
                    "np": 3,
                    "cix": 2,
                    "ix": 1,
                    "mn": "ADBE Vector Group",
                    "hd": false
                }
            ],
            "ip": 0,
            "op": 750,
            "st": 0,
            "bm": 0
        }
        ],
    "markers": []//暂时没用到，也不推荐使用
}
```

简单讲，通常p之下的k表示位置，s下表示大小，c表示颜色等，另外**位置信息一般表示图形中心点相对父层的位置而不是相对原始画布的位置**，这一点要特别注意。大小有两种，使用**图片的一般使用缩放比来表示大小，而普通图形则为具体尺寸**。

首先如果不修改原始画布大小，则lottie会根据展示区域的大小自动缩放整个图形，那么相应的所有元素都会被缩放，所以我们想要的聊天气泡一定是要先修改画布大小的，修改完大小后内部的各个相对点位也都要做相应调整。

我们把气泡划分几个区域来分析

![](data:image/jpeg;base64,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)

划分成如上9块区域，规定横向为x轴，纵向为y轴。其中左上角内容不需要做任何变更，即可保持原始状态，右上角区域需要修改x轴位置坐标即可，上边区域需要修改x轴位置及x轴大小，下面几块区域依此类推。我们需要制定以下规则来达成修改对应值的目的(a表示原始值，dif表示差值，rat表示比例值)。

 1. 差值相加$a=a+dif$
 2. 差值相减$a=a-dif$
 3. 比例相乘$a=a*rat$
 4. 半差相加$a=a+\frac{dif}{2}$
 5. 半差相减$a=a-\frac{dif}{2}$
 6. 图片比例s的修改 $a=a+\frac{100*dif}{b}$ b为图片原始尺寸，由于比例值本身是乘以100的，所以这里计算也要乘100

参考lottie源码，该部分内容均由*LOTKeyframe*实现，而s和p等在json中是同级的，并且x，y，z轴是分开的，因此我们制定如下规则，采用6位16进制数表示(json文件中应转换为对应的十进制数值存储)，前三位表示大小的修改(s)，后三位表示未知的修改(p)，三位分别对应 z y x。数值定义如下

16进制 前三位大小、后三位位置 zyx，运算方法与数值如上边规则所示。eg:0x012045->69649表示宽度(大小x轴)需要加上原始画布与结果画布的宽度差，高度(大小y轴)需要减去原始画布与结果画布的高度差，x轴位置需要加上原始画布与结果画布的宽度差的一般，y轴位置需要减去原始画布与结果画布的高度差的一般。

####使用说明

由于lottie不支持网络地址图片加载，需要调用内部方法等问题，所以对lottie原始框架内做了部分更改，其他均为扩展或子类实现。建议将demo中的*LottieExtension*(自定内容)和*lottie-ios*(原始框架)直接放入项目中使用。使用时只需使用*RAAnimationView*替换气泡图层即可。

修改lottie文件摘要如下：
 
 - LOTAnimationView.h

由于lottie对AE插件导出后的图片资源是不在json中的，所以做了一个简易的mac程序来自动识别并导入图片数据(默认为base64方式)参见*changeBubbleJson*

注意，这个mac程序并不能实现自动添加计算方法的参数，因此需要用户自行修改json，在合适的位置添加pty以实现对应图层的位置大小修改，在最外层添加raty以保证修改画布原始尺寸。

 
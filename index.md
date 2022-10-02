
001110001010100101100101110110010010

## 想找内容请按 `s` 或者用鼠标点击右上角搜索框搜索。


<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>JS Bin</title>
  <style>
      body {
            background-color: black;
            margin: 0;
        }
        .sc {
            animation: f 3s linear infinite alternate;
        }

        .sc2 {
            animation-delay: -1s;
        }

        .sc3 {
            animation-delay: -2s;
        }

        @keyframes f {
            0% {
                stop-color: pink;
            }
            35% {
                stop-color: crimson;
            }
            50% {
                stop-color: purple;
            }
            85% {
                stop-color: yellow;
            }
            100% {
                stop-color: orange;
            }
        }

  </style>
</head>
<body>
<svg width="500" height="500" viewBox="0 0 480 352" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <mask id="mask1" maskContentUnits="userSpaceOnUse">
      <image width="480" height="352" xlink:href="https://i.pinimg.com/originals/3d/cb/c2/3dcbc2ba6a3f6ded21c66f23b1b9b2cb.gif">
      </image>
    </mask>
    <linearGradient id="lg1" x1="0" y1="0" x2="100%" y2="100%">
      <stop offset="15%" class="sc sc1"></stop>
      <stop offset="45%" class="sc sc2"></stop>
      <stop offset="55%" class="sc sc2"></stop>
      <stop offset="85%" class="sc sc3"></stop>
    </linearGradient>
  </defs>
  <rect fill="url(#lg1)" mask="url(#mask1)" width="100%" height="100%">
  </rect>
  </svg>
</body>
</html>

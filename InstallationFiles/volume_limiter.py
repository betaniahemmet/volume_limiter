import time
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
from comtypes import CLSCTX_ALL
from ctypes import POINTER, cast

__version__ = "1.0.0"
MAX_VOLUME = 0.5
CHECK_INTERVAL = 1.0

def get_volume_interface():
    devices = AudioUtilities.GetSpeakers()
    interface = devices.Activate(IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
    return cast(interface, POINTER(IAudioEndpointVolume))

def enforce(volume_interface):
    current = volume_interface.GetMasterVolumeLevelScalar()
    if current > MAX_VOLUME:
        volume_interface.SetMasterVolumeLevelScalar(MAX_VOLUME, None)

def main():
    vi = get_volume_interface()
    while True:
        enforce(vi)
        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()


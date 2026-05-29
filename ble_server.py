import asyncio
import random

from bless import (
    BlessServer,
    GATTCharacteristicProperties,
    GATTAttributePermissions,
)

SERVICE_UUID = "12345678-1234-5678-1234-56789abcdef0"
CHAR_UUID = "12345678-1234-5678-1234-56789abcdef1"
TEMP_CHAR_UUID  = "12345678-1234-5678-1234-56789abcdef2"


async def run():

    print("Initializing BLE server...")

    server = BlessServer(name="TestBLEDevice")

    await server.add_new_service(SERVICE_UUID)

    await server.add_new_characteristic(
    SERVICE_UUID,
    CHAR_UUID,
    GATTCharacteristicProperties.notify,
    None,
    GATTAttributePermissions.readable,
)
    await server.add_new_characteristic(
    SERVICE_UUID,
    TEMP_CHAR_UUID,
    GATTCharacteristicProperties.notify,
    None,
    GATTAttributePermissions.readable,
)

    print("Starting BLE server...")

    await server.start()

    print("BLE Peripheral Started")

    counter = 0
    temperature=25
    while True:

        data = f"{counter}"
        temp_data = f"{temperature}"

        characteristic = server.get_characteristic(
            CHAR_UUID
        )

        characteristic.value = bytearray(
            data,
            "utf-8",
        )

        server.update_value(
            SERVICE_UUID,
            CHAR_UUID,
        )

        print("Sent:", data)
        await asyncio.sleep(0.1)

        temp_char = server.get_characteristic(TEMP_CHAR_UUID)
        temp_char.value = bytearray(temp_data, "utf-8")

        server.update_value(
          SERVICE_UUID,
          TEMP_CHAR_UUID,
        )
        print("temp:", temp_data)
        counter += 1
        change = random.randint(-5, 5)
        temperature += change
        await asyncio.sleep(2)


asyncio.run(run())
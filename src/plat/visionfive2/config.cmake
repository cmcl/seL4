#
# Copyright 2023, Ivan Velickovic
# Copyright 2025, Craig McLaughlin
#
# SPDX-License-Identifier: GPL-2.0-only
#

declare_platform(visionfive2 KernelPlatformVisionFive2 PLAT_VISIONFIVE2 KernelArchRiscV)

if(KernelPlatformVisionFive2)
    declare_seL4_arch(riscv64)
    config_set(KernelRiscVPlatform RISCV_PLAT "visionfive2")
    # The JH7110 SoC contains the SiFive U74-MC core complex. This has four U74
    # cores and one S7 core (which has a hart ID of 0). The first U74 core has
    # a hart ID of 1.
    config_set(KernelPlatformFirstHartID FIRST_HART_ID 1)
    config_set(KernelOpenSBIPlatform OPENSBI_PLATFORM "generic")
    # Note that by default the kernel is configured for the 8GB VisionFive-2 model.
    list(APPEND KernelDTSList "tools/dts/visionfive2.dts")
    list(APPEND KernelDTSList "${CMAKE_CURRENT_LIST_DIR}/overlay-visionfive2.dts")
    # The value for TIMER_FREQUENCY is from the "timebase-frequency"
    # field on the "cpus" node in the VisionFive-2 device tree except
    # there is weirdness in the device tree compilation process which
    # produces "\0=\t" as the value despite the actual value being
    # available in the common dtsi file.
    # The value for MAX_IRQ comes from the DTS "interrupt-controller"
    # node which says "riscv,ndev = <0x88>".
    declare_default_headers(
        TIMER_FREQUENCY 4000000
        MAX_IRQ 136
        INTERRUPT_CONTROLLER drivers/irq/riscv_plic0.h
    )
else()
    unset(KernelPlatformFirstHartID CACHE)
endif()

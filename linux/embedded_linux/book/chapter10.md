# Chapter 10: MTD Subsystem

## MTD Overview

- MTD = Memory Technology Device
- enables the separation of the low-level device complexities from the
higher-layer data organization and storage formats that use memory and flash
devices
- device driver layer that provides a uniform API for interfacing with raw flash
devices
- MTD supports a wide variety of flash devices
- MTD is not a block device:
    * variable block sizes
    * three primary operations: read, write, erase
    * MTD devices have a limited write life cycle
    * MTD has logic to spread the write operations over the device's life span
    to increase the device's life span -> wear leveling
- SD/MMC cards, CompactFlash cards, USB flash drives are not MTD devices as they
all contain internal flash translation layers that handle MTD-like functions
such as block erasure and wear leveling -> appear to the system as traditional
block devices and do not need handling of MTD
- MTD must be enabled in the kernel configuration
- what needs to be configured for custom flash:
    * specify partitioning on flash device
    * specify the type of flash and location
    * configure the proper flash driver for your chosen chip
    * configure the kernel the appropriate driver

## MTD Partitions

- most flash devices are divided into several sections (partitions)
- MTD support flash partitions
- the following partitioning methods are currently supported:
    * Redboot partition table parsing
    * Kernel command-line partition table definition
    * Board-specific mapping drivers
- a mapping driver together with definitions supplied by your architecture-specific
board support, defines your flash configuration to the kernel

## MTD Utilities

- caution when using these utilities, because Linux provides no protection from
mistakes
- `flash_*` utilities (`flashcp,flash_erase,flash_info,flash_lock,flash_unlock`):
useful for raw device operations on an MTD partition

## UBI File System

- UBI = Unsorted Block Image
- designed to overcome some of the limitations of the JFFS2 file system
- successor to JFFS2: better mount time
- layered on top of UBI devices, which depend on MTD devices
- JFFS2 maintains its indexing metadata in system memory and must read this index
to build a complete directory tree each time the system boots -> takes time
- UBIFS maintains its indexing metadata on the flash device itself -> no need to
scan and rebuild this data on each mount -> much fast mount times than JFFS2
- UBIFS also supports write caching -> performance enhancement
- buildling a UBIFS image is more tricky than building a JFFS2 image -> requires
knowledge of NAND flash architecture on target device


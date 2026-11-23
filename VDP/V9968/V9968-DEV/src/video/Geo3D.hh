// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Alex Moncks
//
// Geo3D: the geo3d 3D coprocessor (V9968_Cartridge, geo3d/) as an openMSX
// device. Two I/O ports: base+5 (index write / status read) and base+7
// (data). On RUN it hands the frame's LINE/LRMM commands to the VDP command
// engine, one after the other, whenever the engine is idle (CE = 0), through
// the same register path as a Z80 write. RUN busy (status bit 0) clears once
// the last command has finished, like the RTL's R_DRAIN state.
//
// Not cycle exact: the transform/clip work takes no emulated time and a
// command is issued at most `poll` after the previous one finished.

#ifndef GEO3D_HH
#define GEO3D_HH

#include "Geo3DCore.hh"
#include "MSXDevice.hh"
#include "Schedulable.hh"

#include <string>

namespace openmsx {

class VDP;

class Geo3D final : public MSXDevice, public Schedulable
{
public:
	explicit Geo3D(const DeviceConfig& config);

	void init() override;
	void reset(EmuTime time) override;
	[[nodiscard]] uint8_t readIO(uint16_t port, EmuTime time) override;
	[[nodiscard]] uint8_t peekIO(uint16_t port, EmuTime time) const override;
	void writeIO(uint16_t port, uint8_t value, EmuTime time) override;

	template<typename Archive>
	void serialize(Archive& ar, unsigned version);

private:
	// Schedulable
	void executeUntil(EmuTime time) override;

	// Feeds the VDP while it is idle; reschedules itself while it is busy.
	void pump(EmuTime time);

	Geo3DCore core;
	std::string vdpName;
	VDP* vdp = nullptr;
};

} // namespace openmsx

#endif

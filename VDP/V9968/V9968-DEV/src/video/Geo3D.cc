// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Alex Moncks

#include "Geo3D.hh"

#include "MSXException.hh"
#include "MSXMotherBoard.hh"
#include "VDP.hh"
#include "VDPCmdEngine.hh"
#include "serialize.hh"
#include "serialize_stl.hh"

namespace openmsx {

// How often a busy VDP is checked: 16 VDP clocks (~0.75 us).
static constexpr auto POLL = EmuDuration::nsec(745);

Geo3D::Geo3D(const DeviceConfig& config)
	: MSXDevice(config)
	, Schedulable(getMotherBoard().getScheduler())
	, vdpName(config.getChildData("vdp", "VDP"))
{
}

void Geo3D::init()
{
	MSXDevice::init();
	vdp = dynamic_cast<VDP*>(getMotherBoard().findDevice(vdpName));
	if (!vdp) {
		throw MSXException("Geo3D: no VDP named \"", vdpName, "\" in this machine.");
	}
	if (!vdp->isV9968_Old() && !vdp->isV9968_New()) {
		throw MSXException("Geo3D requires a V9968 VDP.");
	}
}

void Geo3D::reset(EmuTime /*time*/)
{
	removeSyncPoint();
	core.reset();
}

// base+5 (e.g. 0x8D, 0x9D) has bit 1 clear, base+7 has it set
static bool isDataPort(uint16_t port) { return (port & 0x02) != 0; }

uint8_t Geo3D::readIO(uint16_t port, EmuTime time)
{
	if (core.isRunning()) pump(time);     // status as of this very read
	return isDataPort(port) ? core.readData() : core.readStatus();
}

uint8_t Geo3D::peekIO(uint16_t port, EmuTime /*time*/) const
{
	return isDataPort(port) ? core.peekData() : core.readStatus();
}

void Geo3D::writeIO(uint16_t port, uint8_t value, EmuTime time)
{
	if (!isDataPort(port)) {
		core.writeIndex(value);
		return;
	}
	bool wasRunning = core.isRunning();
	core.writeData(value);
	if (!wasRunning && core.isRunning()) pump(time);
}

void Geo3D::pump(EmuTime time)
{
	auto& engine = vdp->getCmdEngine();
	while (true) {
		if (engine.peekStatus2(time) & 0x01) {   // CE: VDP still busy
			removeSyncPoint();
			setSyncPoint(time + POLL);
			return;
		}
		if (!core.hasCommand()) {
			core.finishRun();                    // last command done
			removeSyncPoint();
			return;
		}
		const auto& c = core.nextCommand();
		for (unsigned k = 0; k < c.size; ++k) {
			vdp->changeRegister(uint8_t(c.regNum(k)), c.bytes[k], time);
		}
	}
}

void Geo3D::executeUntil(EmuTime time)
{
	if (core.isRunning()) pump(time);
}

template<typename Archive>
void Geo3D::serialize(Archive& ar, unsigned /*version*/)
{
	ar.template serializeBase<MSXDevice>(*this);
	ar.template serializeBase<Schedulable>(*this);
	std::vector<uint8_t> state;
	if constexpr (!Archive::IS_LOADER) state = core.saveState();
	ar.serialize("core", state);
	if constexpr (Archive::IS_LOADER) {
		if (!core.loadState(state)) throw MSXException("Invalid Geo3D save state.");
	}
}
INSTANTIATE_SERIALIZE_METHODS(Geo3D);
REGISTER_MSXDEVICE(Geo3D, "Geo3D");

} // namespace openmsx

function net.WriteCompressedTable( tbl )
	local binary = util.Compress(util.TableToJSON(tbl))
	net.WriteUInt(#binary, 16)
	net.WriteData(binary, #binary)
end

function net.ReadCompressedTable()
	return util.JSONToTable(util.Decompress(net.ReadData(net.ReadUInt(16))))
end

function net.WriteCompressedString( str )
	local binary = util.Compress(str)
	net.WriteUInt(#binary, 16)
	net.WriteData(binary, #binary)
end

function net.ReadCompressedString()
	return util.Decompress(net.ReadData(net.ReadUInt(16)))
end
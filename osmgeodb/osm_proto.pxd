from libc.stdint cimport *
from libc.string cimport *
from cpython.ref cimport PyObject

from pyrobuf_list cimport *
from pyrobuf_util cimport *

import json

cdef class Blob:


    cdef bytes _raw
    cdef int32_t _raw_size
    cdef bytes _zlib_data
    cdef bytes _lzma_data
    cdef bytes _OBSOLETE_bzip2_data


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, Blob other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, Blob other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class BlobHeader:


    cdef str _type
    cdef bytes _indexdata
    cdef int32_t _datasize


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, BlobHeader other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, BlobHeader other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class HeaderBlock:


    cdef HeaderBBox _bbox
    cdef StringList _required_features
    cdef StringList _optional_features
    cdef str _writingprogram
    cdef str _source


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, HeaderBlock other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, HeaderBlock other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class HeaderBBox:


    cdef int64_t _left
    cdef int64_t _right
    cdef int64_t _top
    cdef int64_t _bottom


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, HeaderBBox other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, HeaderBBox other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class PrimitiveBlock:


    cdef StringTable _stringtable
    cdef TypedList _primitivegroup
    cdef int32_t _granularity
    cdef int32_t _date_granularity
    cdef int64_t _lat_offset
    cdef int64_t _lon_offset


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, PrimitiveBlock other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, PrimitiveBlock other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class PrimitiveGroup:


    cdef TypedList _nodes
    cdef DenseNodes _dense
    cdef TypedList _ways
    cdef TypedList _relations
    cdef TypedList _changesets


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, PrimitiveGroup other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, PrimitiveGroup other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class StringTable:


    cdef BytesList _s


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, StringTable other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, StringTable other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class Info:


    cdef int32_t _version
    cdef int64_t _timestamp
    cdef int64_t _changeset
    cdef int32_t _uid
    cdef uint32_t _user_sid


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, Info other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, Info other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class DenseInfo:


    cdef Int32List _version
    cdef Int64List _timestamp
    cdef Int64List _changeset
    cdef Int32List _uid
    cdef Int32List _user_sid


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, DenseInfo other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, DenseInfo other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class ChangeSet:


    cdef int64_t _id


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, ChangeSet other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, ChangeSet other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class Node:


    cdef int64_t _id
    cdef Uint32List _keys
    cdef Uint32List _vals
    cdef Info _info
    cdef int64_t _lat
    cdef int64_t _lon


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, Node other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, Node other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class DenseNodes:


    cdef Int64List _id
    cdef DenseInfo _denseinfo
    cdef Int64List _lat
    cdef Int64List _lon
    cdef Int32List _keys_vals


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, DenseNodes other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, DenseNodes other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class Way:


    cdef int64_t _id
    cdef Uint32List _keys
    cdef Uint32List _vals
    cdef Info _info
    cdef Int64List _refs


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, Way other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, Way other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class Relation:


    cdef int64_t _id
    cdef Uint32List _keys
    cdef Uint32List _vals
    cdef Info _info
    cdef Int32List _roles_sid
    cdef Int64List _memids
    cdef Int32List _types


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef PyObject *_listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, Relation other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, Relation other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef enum _RelationMemberType:
    _RelationMemberType_NODE = 0
    _RelationMemberType_WAY = 1
    _RelationMemberType_RELATION = 2
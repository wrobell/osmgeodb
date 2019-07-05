from libc.stdint cimport *
from libc.string cimport *
from cpython.ref cimport PyObject

from pyrobuf_list cimport *
from pyrobuf_util cimport *

import base64
import json
import warnings

class DecodeError(Exception):
    pass

cdef class Blob:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'raw',
                          'raw_size',
                          'zlib_data',
                          'lzma_data',
                          'OBSOLETE_bzip2_data',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._raw = b""
        self._raw_size = 0
        self._zlib_data = b""
        self._lzma_data = b""
        self._OBSOLETE_bzip2_data = b""
        return

    
    @property
    def raw(self):
        return self._raw

    @raw.setter
    def raw(self, value):
        self.__field_bitmap0 |= 1
        if isinstance(value, bytes):
            self._raw = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s,)" % (value, type(value), bytes))
        self._Modified()
    
    @property
    def raw_size(self):
        return self._raw_size

    @raw_size.setter
    def raw_size(self, value):
        self.__field_bitmap0 |= 2
        self._raw_size = value
        self._Modified()
    
    @property
    def zlib_data(self):
        return self._zlib_data

    @zlib_data.setter
    def zlib_data(self, value):
        self.__field_bitmap0 |= 4
        if isinstance(value, bytes):
            self._zlib_data = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s,)" % (value, type(value), bytes))
        self._Modified()
    
    @property
    def lzma_data(self):
        return self._lzma_data

    @lzma_data.setter
    def lzma_data(self, value):
        self.__field_bitmap0 |= 8
        if isinstance(value, bytes):
            self._lzma_data = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s,)" % (value, type(value), bytes))
        self._Modified()
    
    @property
    def OBSOLETE_bzip2_data(self):
        warnings.warn("field 'OBSOLETE_bzip2_data' is deprecated", DeprecationWarning)
        return self._OBSOLETE_bzip2_data

    @OBSOLETE_bzip2_data.setter
    def OBSOLETE_bzip2_data(self, value):
        warnings.warn("field 'OBSOLETE_bzip2_data' is deprecated", DeprecationWarning)
        self.__field_bitmap0 |= 16
        if isinstance(value, bytes):
            self._OBSOLETE_bzip2_data = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s,)" % (value, type(value), bytes))
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # raw
            if key == 10:
                self.__field_bitmap0 |= 1
                field_size = get_varint64(memory, &current_offset)
                self._raw = memory[current_offset:current_offset + field_size]
                current_offset += <int>field_size
            # raw_size
            elif key == 16:
                self.__field_bitmap0 |= 2
                self._raw_size = get_varint32(memory, &current_offset)
            # zlib_data
            elif key == 26:
                self.__field_bitmap0 |= 4
                field_size = get_varint64(memory, &current_offset)
                self._zlib_data = memory[current_offset:current_offset + field_size]
                current_offset += <int>field_size
            # lzma_data
            elif key == 34:
                self.__field_bitmap0 |= 8
                field_size = get_varint64(memory, &current_offset)
                self._lzma_data = memory[current_offset:current_offset + field_size]
                current_offset += <int>field_size
            # OBSOLETE_bzip2_data
            elif key == 42:
                self.__field_bitmap0 |= 16
                field_size = get_varint64(memory, &current_offset)
                self._OBSOLETE_bzip2_data = memory[current_offset:current_offset + field_size]
                current_offset += <int>field_size
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'raw':
            self.__field_bitmap0 &= ~1
            self._raw = b""
        elif field_name == 'raw_size':
            self.__field_bitmap0 &= ~2
            self._raw_size = 0
        elif field_name == 'zlib_data':
            self.__field_bitmap0 &= ~4
            self._zlib_data = b""
        elif field_name == 'lzma_data':
            self.__field_bitmap0 &= ~8
            self._lzma_data = b""
        elif field_name == 'OBSOLETE_bzip2_data':
            self.__field_bitmap0 &= ~16
            self._OBSOLETE_bzip2_data = b""
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, Blob other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (Blob): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'raw':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'raw_size':
            return self.__field_bitmap0 & 2 == 2
        if field_name == 'zlib_data':
            return self.__field_bitmap0 & 4 == 4
        if field_name == 'lzma_data':
            return self.__field_bitmap0 & 8 == 8
        if field_name == 'OBSOLETE_bzip2_data':
            return self.__field_bitmap0 & 16 == 16
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    

        return True

    cpdef void MergeFrom(self, Blob other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._raw = other_msg._raw
            self.__field_bitmap0 |= 1
        if other_msg.__field_bitmap0 & 2 == 2:
            self._raw_size = other_msg._raw_size
            self.__field_bitmap0 |= 2
        if other_msg.__field_bitmap0 & 4 == 4:
            self._zlib_data = other_msg._zlib_data
            self.__field_bitmap0 |= 4
        if other_msg.__field_bitmap0 & 8 == 8:
            self._lzma_data = other_msg._lzma_data
            self.__field_bitmap0 |= 8
        if other_msg.__field_bitmap0 & 16 == 16:
            self._OBSOLETE_bzip2_data = other_msg._OBSOLETE_bzip2_data
            self.__field_bitmap0 |= 16

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        # raw
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(10, buf)
            set_varint64(len(self._raw), buf)
            buf += self._raw
        # raw_size
        if self.__field_bitmap0 & 2 == 2:
            set_varint64(16, buf)
            set_varint32(self._raw_size, buf)
        # zlib_data
        if self.__field_bitmap0 & 4 == 4:
            set_varint64(26, buf)
            set_varint64(len(self._zlib_data), buf)
            buf += self._zlib_data
        # lzma_data
        if self.__field_bitmap0 & 8 == 8:
            set_varint64(34, buf)
            set_varint64(len(self._lzma_data), buf)
            buf += self._lzma_data
        # OBSOLETE_bzip2_data
        if self.__field_bitmap0 & 16 == 16:
            set_varint64(42, buf)
            set_varint64(len(self._OBSOLETE_bzip2_data), buf)
            buf += self._OBSOLETE_bzip2_data

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.raw = base64.b64decode(d["raw"].encode('utf-8'))
        except KeyError:
            pass
        try:
            self.raw_size = d["raw_size"]
        except KeyError:
            pass
        try:
            self.zlib_data = base64.b64decode(d["zlib_data"].encode('utf-8'))
        except KeyError:
            pass
        try:
            self.lzma_data = base64.b64decode(d["lzma_data"].encode('utf-8'))
        except KeyError:
            pass
        try:
            self.OBSOLETE_bzip2_data = base64.b64decode(d["OBSOLETE_bzip2_data"].encode('utf-8'))
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["raw"] = base64.b64encode(self.raw).decode('utf-8')
        if self.__field_bitmap0 & 2 == 2:
            out["raw_size"] = self.raw_size
        if self.__field_bitmap0 & 4 == 4:
            out["zlib_data"] = base64.b64encode(self.zlib_data).decode('utf-8')
        if self.__field_bitmap0 & 8 == 8:
            out["lzma_data"] = base64.b64encode(self.lzma_data).decode('utf-8')
        if self.__field_bitmap0 & 16 == 16:
            out["OBSOLETE_bzip2_data"] = base64.b64encode(self.OBSOLETE_bzip2_data).decode('utf-8')

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["raw"] = base64.b64encode(self.raw).decode('utf-8')
        if self.__field_bitmap0 & 2 == 2:
            out["raw_size"] = self.raw_size
        if self.__field_bitmap0 & 4 == 4:
            out["zlib_data"] = base64.b64encode(self.zlib_data).decode('utf-8')
        if self.__field_bitmap0 & 8 == 8:
            out["lzma_data"] = base64.b64encode(self.lzma_data).decode('utf-8')
        if self.__field_bitmap0 & 16 == 16:
            out["OBSOLETE_bzip2_data"] = base64.b64encode(self.OBSOLETE_bzip2_data).decode('utf-8')

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'raw', self.raw
        yield 'raw_size', self.raw_size
        yield 'zlib_data', self.zlib_data
        yield 'lzma_data', self.lzma_data
        yield 'OBSOLETE_bzip2_data', self.OBSOLETE_bzip2_data

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'raw'
        yield 'raw_size'
        yield 'zlib_data'
        yield 'lzma_data'
        yield 'OBSOLETE_bzip2_data'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.raw
        yield self.raw_size
        yield self.zlib_data
        yield self.lzma_data
        yield self.OBSOLETE_bzip2_data

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.raw = value
        yield setter
        def setter(value):
            self.raw_size = value
        yield setter
        def setter(value):
            self.zlib_data = value
        yield setter
        def setter(value):
            self.lzma_data = value
        yield setter
        def setter(value):
            self.OBSOLETE_bzip2_data = value
        yield setter

    


cdef class BlobHeader:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'type',
                          'indexdata',
                          'datasize',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._type = ""
        self._indexdata = b""
        self._datasize = 0
        return

    
    @property
    def type(self):
        return self._type

    @type.setter
    def type(self, value):
        self.__field_bitmap0 |= 1
        if isinstance(value, bytes):
            self._type = value.decode('utf-8')
        elif isinstance(value, str):
            self._type = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def indexdata(self):
        return self._indexdata

    @indexdata.setter
    def indexdata(self, value):
        self.__field_bitmap0 |= 2
        if isinstance(value, bytes):
            self._indexdata = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s,)" % (value, type(value), bytes))
        self._Modified()
    
    @property
    def datasize(self):
        return self._datasize

    @datasize.setter
    def datasize(self, value):
        self.__field_bitmap0 |= 4
        self._datasize = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # type
            if key == 10:
                self.__field_bitmap0 |= 1
                field_size = get_varint64(memory, &current_offset)
                self._type = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # indexdata
            elif key == 18:
                self.__field_bitmap0 |= 2
                field_size = get_varint64(memory, &current_offset)
                self._indexdata = memory[current_offset:current_offset + field_size]
                current_offset += <int>field_size
            # datasize
            elif key == 24:
                self.__field_bitmap0 |= 4
                self._datasize = get_varint32(memory, &current_offset)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'type':
            self.__field_bitmap0 &= ~1
            self._type = ""
        elif field_name == 'indexdata':
            self.__field_bitmap0 &= ~2
            self._indexdata = b""
        elif field_name == 'datasize':
            self.__field_bitmap0 &= ~4
            self._datasize = 0
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, BlobHeader other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (BlobHeader): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'type':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'indexdata':
            return self.__field_bitmap0 & 2 == 2
        if field_name == 'datasize':
            return self.__field_bitmap0 & 4 == 4
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self.__field_bitmap0 & 1 != 1:
            return False
        if self.__field_bitmap0 & 4 != 4:
            return False

        return True

    cpdef void MergeFrom(self, BlobHeader other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._type = other_msg._type
            self.__field_bitmap0 |= 1
        if other_msg.__field_bitmap0 & 2 == 2:
            self._indexdata = other_msg._indexdata
            self.__field_bitmap0 |= 2
        if other_msg.__field_bitmap0 & 4 == 4:
            self._datasize = other_msg._datasize
            self.__field_bitmap0 |= 4

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        # type
        cdef bytes type_bytes
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(10, buf)
            type_bytes = self._type.encode('utf-8')
            set_varint64(len(type_bytes), buf)
            buf += type_bytes
        # indexdata
        if self.__field_bitmap0 & 2 == 2:
            set_varint64(18, buf)
            set_varint64(len(self._indexdata), buf)
            buf += self._indexdata
        # datasize
        if self.__field_bitmap0 & 4 == 4:
            set_varint64(24, buf)
            set_varint32(self._datasize, buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'type' not initialized and does not have default")
        if self.__field_bitmap0 & 4 != 4:
            raise Exception("required field 'datasize' not initialized and does not have default")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.type = d["type"]
        except KeyError:
            pass
        try:
            self.indexdata = base64.b64decode(d["indexdata"].encode('utf-8'))
        except KeyError:
            pass
        try:
            self.datasize = d["datasize"]
        except KeyError:
            pass

        self._Modified()
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'type' not initialized and does not have default")
        if self.__field_bitmap0 & 4 != 4:
            raise Exception("required field 'datasize' not initialized and does not have default")

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'type' not initialized and does not have default")
        if self.__field_bitmap0 & 4 != 4:
            raise Exception("required field 'datasize' not initialized and does not have default")
        if self.__field_bitmap0 & 1 == 1:
            out["type"] = self.type
        if self.__field_bitmap0 & 2 == 2:
            out["indexdata"] = base64.b64encode(self.indexdata).decode('utf-8')
        if self.__field_bitmap0 & 4 == 4:
            out["datasize"] = self.datasize

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["type"] = self.type
        if self.__field_bitmap0 & 2 == 2:
            out["indexdata"] = base64.b64encode(self.indexdata).decode('utf-8')
        if self.__field_bitmap0 & 4 == 4:
            out["datasize"] = self.datasize

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'type', self.type
        yield 'indexdata', self.indexdata
        yield 'datasize', self.datasize

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'type'
        yield 'indexdata'
        yield 'datasize'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.type
        yield self.indexdata
        yield self.datasize

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.type = value
        yield setter
        def setter(value):
            self.indexdata = value
        yield setter
        def setter(value):
            self.datasize = value
        yield setter

    


cdef class HeaderBlock:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._bbox is not None:
            self._bbox._listener = <PyObject *>null_listener
        if self._required_features is not None:
            self._required_features._listener = <PyObject *>null_listener
        if self._optional_features is not None:
            self._optional_features._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('bbox',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('required_features','optional_features',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'required_features',
                          'optional_features',
                          'writingprogram',
                          'source',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'bbox',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        if self._bbox is not None:
            self._bbox._listener = <PyObject *>null_listener
        self._bbox = None
        if self._required_features is not None:
            self._required_features._listener = <PyObject *>null_listener
        self._required_features = StringList.__new__(StringList)
        self._required_features._listener = <PyObject *>self
        if self._optional_features is not None:
            self._optional_features._listener = <PyObject *>null_listener
        self._optional_features = StringList.__new__(StringList)
        self._optional_features._listener = <PyObject *>self
        self._writingprogram = ""
        self._source = ""
        return

    
    @property
    def bbox(self):
        # lazy init sub messages
        if self._bbox is None:
            self._bbox = HeaderBBox.__new__(HeaderBBox)
            self._bbox.reset()
            self._bbox._listener = <PyObject *>self
        return self._bbox

    @bbox.setter
    def bbox(self, value):
        if self._bbox is not None:
            self._bbox._listener = <PyObject *>null_listener
        self._bbox = value
        self._bbox._listener = <PyObject *>self
        self._Modified()
    
    @property
    def required_features(self):
        return self._required_features

    @required_features.setter
    def required_features(self, value):
        if self._required_features is not None:
            self._required_features._listener = <PyObject *>null_listener
        self._required_features = StringList.__new__(StringList)
        self._required_features._listener = <PyObject *>self
        for val in value:
            if isinstance(val, bytes):
                list.append(self._required_features, val.decode('utf-8'))
            elif isinstance(val, str):
                list.append(self._required_features, val)
            else:
                raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (val, type(val), bytes, str))
        self._Modified()
    
    @property
    def optional_features(self):
        return self._optional_features

    @optional_features.setter
    def optional_features(self, value):
        if self._optional_features is not None:
            self._optional_features._listener = <PyObject *>null_listener
        self._optional_features = StringList.__new__(StringList)
        self._optional_features._listener = <PyObject *>self
        for val in value:
            if isinstance(val, bytes):
                list.append(self._optional_features, val.decode('utf-8'))
            elif isinstance(val, str):
                list.append(self._optional_features, val)
            else:
                raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (val, type(val), bytes, str))
        self._Modified()
    
    @property
    def writingprogram(self):
        return self._writingprogram

    @writingprogram.setter
    def writingprogram(self, value):
        self.__field_bitmap0 |= 32768
        if isinstance(value, bytes):
            self._writingprogram = value.decode('utf-8')
        elif isinstance(value, str):
            self._writingprogram = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    
    @property
    def source(self):
        return self._source

    @source.setter
    def source(self, value):
        self.__field_bitmap0 |= 65536
        if isinstance(value, bytes):
            self._source = value.decode('utf-8')
        elif isinstance(value, str):
            self._source = value
        else:
            raise TypeError("%r has type %s, but expected one of: (%s, %s)" % (value, type(value), bytes, str))
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef str required_features_elt
        cdef str optional_features_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # bbox
            if key == 10:
                field_size = get_varint64(memory, &current_offset)
                if self._bbox is None:
                    self._bbox = HeaderBBox.__new__(HeaderBBox)
                    self._bbox._listener = <PyObject *>self
                self._bbox.reset()
                if cache:
                    self._bbox._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._bbox._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # required_features
            elif key == 34:
                field_size = get_varint64(memory, &current_offset)
                required_features_elt = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
                list.append(self._required_features, required_features_elt)
            # optional_features
            elif key == 42:
                field_size = get_varint64(memory, &current_offset)
                optional_features_elt = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
                list.append(self._optional_features, optional_features_elt)
            # writingprogram
            elif key == 130:
                self.__field_bitmap0 |= 32768
                field_size = get_varint64(memory, &current_offset)
                self._writingprogram = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # source
            elif key == 138:
                self.__field_bitmap0 |= 65536
                field_size = get_varint64(memory, &current_offset)
                self._source = str(memory[current_offset:current_offset + field_size], 'utf-8')
                current_offset += <int>field_size
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'bbox':
            if self._bbox is not None:
                self._bbox._listener = <PyObject *>null_listener
            self._bbox = None
        elif field_name == 'required_features':
            self._required_features._listener = <PyObject *>null_listener
            self._required_features = StringList.__new__(StringList)
            self._required_features._listener = <PyObject *>self
        elif field_name == 'optional_features':
            self._optional_features._listener = <PyObject *>null_listener
            self._optional_features = StringList.__new__(StringList)
            self._optional_features._listener = <PyObject *>self
        elif field_name == 'writingprogram':
            self.__field_bitmap0 &= ~32768
            self._writingprogram = ""
        elif field_name == 'source':
            self.__field_bitmap0 &= ~65536
            self._source = ""
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, HeaderBlock other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (HeaderBlock): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'bbox':
            return self._bbox is not None and self._bbox._is_present_in_parent
        if field_name == 'writingprogram':
            return self.__field_bitmap0 & 32768 == 32768
        if field_name == 'source':
            return self.__field_bitmap0 & 65536 == 65536
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self._bbox is not None and self._bbox._is_present_in_parent and not self._bbox.IsInitialized():
            return False

        return True

    cpdef void MergeFrom(self, HeaderBlock other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        if other_msg._bbox is not None and other_msg._bbox._is_present_in_parent:
            if self._bbox is None:
                self._bbox = HeaderBBox.__new__(HeaderBBox)
                self._bbox.reset()
                self._bbox._listener = <PyObject *>self
            self._bbox.MergeFrom(other_msg._bbox)
        self._required_features += other_msg._required_features
        self._optional_features += other_msg._optional_features
        if other_msg.__field_bitmap0 & 32768 == 32768:
            self._writingprogram = other_msg._writingprogram
            self.__field_bitmap0 |= 32768
        if other_msg.__field_bitmap0 & 65536 == 65536:
            self._source = other_msg._source
            self.__field_bitmap0 |= 65536

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # bbox
        cdef bytearray bbox_buf
        if self._bbox is not None and self._bbox._is_present_in_parent:
            set_varint64(10, buf)
            if self._bbox._cached_serialization is not None:
                set_varint64(len(self._bbox._cached_serialization), buf)
                buf += self._bbox._cached_serialization
            else:
                bbox_buf = bytearray()
                self._bbox._protobuf_serialize(bbox_buf, cache)
                set_varint64(len(bbox_buf), buf)
                buf += bbox_buf
                if cache:
                    self._bbox._cached_serialization = bytes(bbox_buf)
        # required_features
        cdef str required_features_elt
        cdef bytes required_features_elt_bytes
        for required_features_elt in self._required_features:
            set_varint64(34, buf)
            required_features_elt_bytes = required_features_elt.encode('utf-8')
            set_varint64(len(required_features_elt_bytes), buf)
            buf += required_features_elt_bytes
        # optional_features
        cdef str optional_features_elt
        cdef bytes optional_features_elt_bytes
        for optional_features_elt in self._optional_features:
            set_varint64(42, buf)
            optional_features_elt_bytes = optional_features_elt.encode('utf-8')
            set_varint64(len(optional_features_elt_bytes), buf)
            buf += optional_features_elt_bytes
        # writingprogram
        cdef bytes writingprogram_bytes
        if self.__field_bitmap0 & 32768 == 32768:
            set_varint64(130, buf)
            writingprogram_bytes = self._writingprogram.encode('utf-8')
            set_varint64(len(writingprogram_bytes), buf)
            buf += writingprogram_bytes
        # source
        cdef bytes source_bytes
        if self.__field_bitmap0 & 65536 == 65536:
            set_varint64(138, buf)
            source_bytes = self._source.encode('utf-8')
            set_varint64(len(source_bytes), buf)
            buf += source_bytes

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self._bbox is not None and self._bbox._is_present_in_parent and not self._bbox.IsInitialized():
            raise Exception("Message HeaderBlock is missing required field: bbox")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.bbox.ParseFromDict(d["bbox"])
        except KeyError:
            pass
        try:
            self.required_features = d["required_features"]
        except KeyError:
            pass
        try:
            self.optional_features = d["optional_features"]
        except KeyError:
            pass
        try:
            self.writingprogram = d["writingprogram"]
        except KeyError:
            pass
        try:
            self.source = d["source"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        bbox_dict = self.bbox.SerializeToDict()
        if bbox_dict != {}:
            out["bbox"] = bbox_dict
        if len(self.required_features) > 0:
            out["required_features"] = list(self.required_features)
        if len(self.optional_features) > 0:
            out["optional_features"] = list(self.optional_features)
        if self.__field_bitmap0 & 32768 == 32768:
            out["writingprogram"] = self.writingprogram
        if self.__field_bitmap0 & 65536 == 65536:
            out["source"] = self.source

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        bbox_dict = self.bbox.SerializePartialToDict()
        if bbox_dict != {}:
            out["bbox"] = bbox_dict
        if len(self.required_features) > 0:
            out["required_features"] = list(self.required_features)
        if len(self.optional_features) > 0:
            out["optional_features"] = list(self.optional_features)
        if self.__field_bitmap0 & 32768 == 32768:
            out["writingprogram"] = self.writingprogram
        if self.__field_bitmap0 & 65536 == 65536:
            out["source"] = self.source

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'bbox', self.bbox
        yield 'required_features', self.required_features
        yield 'optional_features', self.optional_features
        yield 'writingprogram', self.writingprogram
        yield 'source', self.source

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'bbox'
        yield 'required_features'
        yield 'optional_features'
        yield 'writingprogram'
        yield 'source'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.bbox
        yield self.required_features
        yield self.optional_features
        yield self.writingprogram
        yield self.source

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.bbox = value
        yield setter
        def setter(value):
            self.required_features = value
        yield setter
        def setter(value):
            self.optional_features = value
        yield setter
        def setter(value):
            self.writingprogram = value
        yield setter
        def setter(value):
            self.source = value
        yield setter

    


cdef class HeaderBBox:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'left',
                          'right',
                          'top',
                          'bottom',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._left = 0
        self._right = 0
        self._top = 0
        self._bottom = 0
        return

    
    @property
    def left(self):
        return self._left

    @left.setter
    def left(self, value):
        self.__field_bitmap0 |= 1
        self._left = value
        self._Modified()
    
    @property
    def right(self):
        return self._right

    @right.setter
    def right(self, value):
        self.__field_bitmap0 |= 2
        self._right = value
        self._Modified()
    
    @property
    def top(self):
        return self._top

    @top.setter
    def top(self, value):
        self.__field_bitmap0 |= 4
        self._top = value
        self._Modified()
    
    @property
    def bottom(self):
        return self._bottom

    @bottom.setter
    def bottom(self, value):
        self.__field_bitmap0 |= 8
        self._bottom = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # left
            if key == 8:
                self.__field_bitmap0 |= 1
                self._left = get_signed_varint64(memory, &current_offset)
            # right
            elif key == 16:
                self.__field_bitmap0 |= 2
                self._right = get_signed_varint64(memory, &current_offset)
            # top
            elif key == 24:
                self.__field_bitmap0 |= 4
                self._top = get_signed_varint64(memory, &current_offset)
            # bottom
            elif key == 32:
                self.__field_bitmap0 |= 8
                self._bottom = get_signed_varint64(memory, &current_offset)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'left':
            self.__field_bitmap0 &= ~1
            self._left = 0
        elif field_name == 'right':
            self.__field_bitmap0 &= ~2
            self._right = 0
        elif field_name == 'top':
            self.__field_bitmap0 &= ~4
            self._top = 0
        elif field_name == 'bottom':
            self.__field_bitmap0 &= ~8
            self._bottom = 0
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, HeaderBBox other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (HeaderBBox): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'left':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'right':
            return self.__field_bitmap0 & 2 == 2
        if field_name == 'top':
            return self.__field_bitmap0 & 4 == 4
        if field_name == 'bottom':
            return self.__field_bitmap0 & 8 == 8
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self.__field_bitmap0 & 1 != 1:
            return False
        if self.__field_bitmap0 & 2 != 2:
            return False
        if self.__field_bitmap0 & 4 != 4:
            return False
        if self.__field_bitmap0 & 8 != 8:
            return False

        return True

    cpdef void MergeFrom(self, HeaderBBox other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._left = other_msg._left
            self.__field_bitmap0 |= 1
        if other_msg.__field_bitmap0 & 2 == 2:
            self._right = other_msg._right
            self.__field_bitmap0 |= 2
        if other_msg.__field_bitmap0 & 4 == 4:
            self._top = other_msg._top
            self.__field_bitmap0 |= 4
        if other_msg.__field_bitmap0 & 8 == 8:
            self._bottom = other_msg._bottom
            self.__field_bitmap0 |= 8

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        # left
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_signed_varint64(self._left, buf)
        # right
        if self.__field_bitmap0 & 2 == 2:
            set_varint64(16, buf)
            set_signed_varint64(self._right, buf)
        # top
        if self.__field_bitmap0 & 4 == 4:
            set_varint64(24, buf)
            set_signed_varint64(self._top, buf)
        # bottom
        if self.__field_bitmap0 & 8 == 8:
            set_varint64(32, buf)
            set_signed_varint64(self._bottom, buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'left' not initialized and does not have default")
        if self.__field_bitmap0 & 2 != 2:
            raise Exception("required field 'right' not initialized and does not have default")
        if self.__field_bitmap0 & 4 != 4:
            raise Exception("required field 'top' not initialized and does not have default")
        if self.__field_bitmap0 & 8 != 8:
            raise Exception("required field 'bottom' not initialized and does not have default")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.left = d["left"]
        except KeyError:
            pass
        try:
            self.right = d["right"]
        except KeyError:
            pass
        try:
            self.top = d["top"]
        except KeyError:
            pass
        try:
            self.bottom = d["bottom"]
        except KeyError:
            pass

        self._Modified()
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'left' not initialized and does not have default")
        if self.__field_bitmap0 & 2 != 2:
            raise Exception("required field 'right' not initialized and does not have default")
        if self.__field_bitmap0 & 4 != 4:
            raise Exception("required field 'top' not initialized and does not have default")
        if self.__field_bitmap0 & 8 != 8:
            raise Exception("required field 'bottom' not initialized and does not have default")

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'left' not initialized and does not have default")
        if self.__field_bitmap0 & 2 != 2:
            raise Exception("required field 'right' not initialized and does not have default")
        if self.__field_bitmap0 & 4 != 4:
            raise Exception("required field 'top' not initialized and does not have default")
        if self.__field_bitmap0 & 8 != 8:
            raise Exception("required field 'bottom' not initialized and does not have default")
        if self.__field_bitmap0 & 1 == 1:
            out["left"] = self.left
        if self.__field_bitmap0 & 2 == 2:
            out["right"] = self.right
        if self.__field_bitmap0 & 4 == 4:
            out["top"] = self.top
        if self.__field_bitmap0 & 8 == 8:
            out["bottom"] = self.bottom

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["left"] = self.left
        if self.__field_bitmap0 & 2 == 2:
            out["right"] = self.right
        if self.__field_bitmap0 & 4 == 4:
            out["top"] = self.top
        if self.__field_bitmap0 & 8 == 8:
            out["bottom"] = self.bottom

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'left', self.left
        yield 'right', self.right
        yield 'top', self.top
        yield 'bottom', self.bottom

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'left'
        yield 'right'
        yield 'top'
        yield 'bottom'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.left
        yield self.right
        yield self.top
        yield self.bottom

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.left = value
        yield setter
        def setter(value):
            self.right = value
        yield setter
        def setter(value):
            self.top = value
        yield setter
        def setter(value):
            self.bottom = value
        yield setter

    


cdef class PrimitiveBlock:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._stringtable is not None:
            self._stringtable._listener = <PyObject *>null_listener
        if self._primitivegroup is not None:
            self._primitivegroup._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('stringtable',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('primitivegroup',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'granularity',
                          'lat_offset',
                          'lon_offset',
                          'date_granularity',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'stringtable',
                            'primitivegroup',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        if self._stringtable is not None:
            self._stringtable._listener = <PyObject *>null_listener
        self._stringtable = None
        if self._primitivegroup is not None:
            self._primitivegroup._listener = <PyObject *>null_listener
        self._primitivegroup = TypedList.__new__(TypedList)
        self._primitivegroup._list_type = PrimitiveGroup
        self._primitivegroup._listener = <PyObject *>self
        self._granularity = 100
        self._lat_offset = 0
        self._lon_offset = 0
        self._date_granularity = 1000
        return

    
    @property
    def stringtable(self):
        # lazy init sub messages
        if self._stringtable is None:
            self._stringtable = StringTable.__new__(StringTable)
            self._stringtable.reset()
            self._stringtable._listener = <PyObject *>self
        return self._stringtable

    @stringtable.setter
    def stringtable(self, value):
        if self._stringtable is not None:
            self._stringtable._listener = <PyObject *>null_listener
        self._stringtable = value
        self._stringtable._listener = <PyObject *>self
        self._Modified()
    
    @property
    def primitivegroup(self):
        # lazy init sub messages
        if self._primitivegroup is None:
            self._primitivegroup = PrimitiveGroup.__new__(PrimitiveGroup)
            self._primitivegroup.reset()
            self._primitivegroup._listener = <PyObject *>self
        return self._primitivegroup

    @primitivegroup.setter
    def primitivegroup(self, value):
        if self._primitivegroup is not None:
            self._primitivegroup._listener = <PyObject *>null_listener
        self._primitivegroup = TypedList.__new__(TypedList)
        self._primitivegroup._list_type = PrimitiveGroup
        self._primitivegroup._listener = <PyObject *>self
        for val in value:
            list.append(self._primitivegroup, val)
        self._Modified()
    
    @property
    def granularity(self):
        return self._granularity

    @granularity.setter
    def granularity(self, value):
        self.__field_bitmap0 |= 65536
        self._granularity = value
        self._Modified()
    
    @property
    def date_granularity(self):
        return self._date_granularity

    @date_granularity.setter
    def date_granularity(self, value):
        self.__field_bitmap0 |= 131072
        self._date_granularity = value
        self._Modified()
    
    @property
    def lat_offset(self):
        return self._lat_offset

    @lat_offset.setter
    def lat_offset(self, value):
        self.__field_bitmap0 |= 262144
        self._lat_offset = value
        self._Modified()
    
    @property
    def lon_offset(self):
        return self._lon_offset

    @lon_offset.setter
    def lon_offset(self, value):
        self.__field_bitmap0 |= 524288
        self._lon_offset = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef PrimitiveGroup primitivegroup_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # stringtable
            if key == 10:
                field_size = get_varint64(memory, &current_offset)
                if self._stringtable is None:
                    self._stringtable = StringTable.__new__(StringTable)
                    self._stringtable._listener = <PyObject *>self
                self._stringtable.reset()
                if cache:
                    self._stringtable._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._stringtable._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # primitivegroup
            elif key == 18:
                primitivegroup_elt = PrimitiveGroup.__new__(PrimitiveGroup)
                primitivegroup_elt.reset()
                field_size = get_varint64(memory, &current_offset)
                if cache:
                    primitivegroup_elt._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += primitivegroup_elt._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
                list.append(self._primitivegroup, primitivegroup_elt)
            # granularity
            elif key == 136:
                self.__field_bitmap0 |= 65536
                self._granularity = get_varint32(memory, &current_offset)
            # date_granularity
            elif key == 144:
                self.__field_bitmap0 |= 131072
                self._date_granularity = get_varint32(memory, &current_offset)
            # lat_offset
            elif key == 152:
                self.__field_bitmap0 |= 262144
                self._lat_offset = get_varint64(memory, &current_offset)
            # lon_offset
            elif key == 160:
                self.__field_bitmap0 |= 524288
                self._lon_offset = get_varint64(memory, &current_offset)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'stringtable':
            if self._stringtable is not None:
                self._stringtable._listener = <PyObject *>null_listener
            self._stringtable = None
        elif field_name == 'primitivegroup':
            if self._primitivegroup is not None:
                self._primitivegroup._listener = <PyObject *>null_listener
            self._primitivegroup = TypedList.__new__(TypedList)
            self._primitivegroup._list_type = PrimitiveGroup
            self._primitivegroup._listener = <PyObject *>self
        elif field_name == 'granularity':
            self.__field_bitmap0 &= ~65536
            self._granularity = 100
        elif field_name == 'date_granularity':
            self.__field_bitmap0 &= ~131072
            self._date_granularity = 1000
        elif field_name == 'lat_offset':
            self.__field_bitmap0 &= ~262144
            self._lat_offset = 0
        elif field_name == 'lon_offset':
            self.__field_bitmap0 &= ~524288
            self._lon_offset = 0
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, PrimitiveBlock other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (PrimitiveBlock): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'stringtable':
            return self._stringtable is not None and self._stringtable._is_present_in_parent
        if field_name == 'granularity':
            return self.__field_bitmap0 & 65536 == 65536
        if field_name == 'date_granularity':
            return self.__field_bitmap0 & 131072 == 131072
        if field_name == 'lat_offset':
            return self.__field_bitmap0 & 262144 == 262144
        if field_name == 'lon_offset':
            return self.__field_bitmap0 & 524288 == 524288
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """
        cdef int i
        cdef PrimitiveGroup primitivegroup_msg

    
        if self._stringtable is None or not self._stringtable.IsInitialized():
            return False
        for i in range(len(self._primitivegroup)):
            primitivegroup_msg = <PrimitiveGroup>self._primitivegroup[i]
            if not primitivegroup_msg.IsInitialized():
                return False

        return True

    cpdef void MergeFrom(self, PrimitiveBlock other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i
        cdef PrimitiveGroup primitivegroup_elt

        if self is other_msg:
            return

    
        if other_msg._stringtable is not None and other_msg._stringtable._is_present_in_parent:
            if self._stringtable is None:
                self._stringtable = StringTable.__new__(StringTable)
                self._stringtable.reset()
                self._stringtable._listener = <PyObject *>self
            self._stringtable.MergeFrom(other_msg._stringtable)
        for i in range(len(other_msg._primitivegroup)):
            primitivegroup_elt = PrimitiveGroup()
            primitivegroup_elt.MergeFrom(other_msg._primitivegroup[i])
            list.append(self._primitivegroup, primitivegroup_elt)
        if other_msg.__field_bitmap0 & 65536 == 65536:
            self._granularity = other_msg._granularity
            self.__field_bitmap0 |= 65536
        if other_msg.__field_bitmap0 & 131072 == 131072:
            self._date_granularity = other_msg._date_granularity
            self.__field_bitmap0 |= 131072
        if other_msg.__field_bitmap0 & 262144 == 262144:
            self._lat_offset = other_msg._lat_offset
            self.__field_bitmap0 |= 262144
        if other_msg.__field_bitmap0 & 524288 == 524288:
            self._lon_offset = other_msg._lon_offset
            self.__field_bitmap0 |= 524288

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # stringtable
        cdef bytearray stringtable_buf
        if self._stringtable is not None and self._stringtable._is_present_in_parent:
            set_varint64(10, buf)
            if self._stringtable._cached_serialization is not None:
                set_varint64(len(self._stringtable._cached_serialization), buf)
                buf += self._stringtable._cached_serialization
            else:
                stringtable_buf = bytearray()
                self._stringtable._protobuf_serialize(stringtable_buf, cache)
                set_varint64(len(stringtable_buf), buf)
                buf += stringtable_buf
                if cache:
                    self._stringtable._cached_serialization = bytes(stringtable_buf)
        # primitivegroup
        cdef PrimitiveGroup primitivegroup_elt
        cdef bytearray primitivegroup_elt_buf
        for primitivegroup_elt in self._primitivegroup:
            set_varint64(18, buf)
            if primitivegroup_elt._cached_serialization is not None:
                set_varint64(len(primitivegroup_elt._cached_serialization), buf)
                buf += primitivegroup_elt._cached_serialization
            else:
                primitivegroup_elt_buf = bytearray()
                primitivegroup_elt._protobuf_serialize(primitivegroup_elt_buf, cache)
                set_varint64(len(primitivegroup_elt_buf), buf)
                buf += primitivegroup_elt_buf
                if cache:
                    primitivegroup_elt._cached_serialization = bytes(primitivegroup_elt_buf)
        # granularity
        if self.__field_bitmap0 & 65536 == 65536:
            set_varint64(136, buf)
            set_varint32(self._granularity, buf)
        # date_granularity
        if self.__field_bitmap0 & 131072 == 131072:
            set_varint64(144, buf)
            set_varint32(self._date_granularity, buf)
        # lat_offset
        if self.__field_bitmap0 & 262144 == 262144:
            set_varint64(152, buf)
            set_varint64(self._lat_offset, buf)
        # lon_offset
        if self.__field_bitmap0 & 524288 == 524288:
            set_varint64(160, buf)
            set_varint64(self._lon_offset, buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        cdef int i
        cdef PrimitiveGroup primitivegroup_msg

    
        if self._stringtable is None or not self._stringtable.IsInitialized():
            raise Exception("required field 'stringtable' not initialized and does not have default")
        for i in range(len(self._primitivegroup)):
            primitivegroup_msg = <PrimitiveGroup>self._primitivegroup[i]
            if not primitivegroup_msg.IsInitialized():
                raise Exception("Message PrimitiveBlock is missing required field: primitivegroup[%d]" % i)

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.stringtable.ParseFromDict(d["stringtable"])
        except KeyError:
            pass
        try:
            for primitivegroup_dict in d["primitivegroup"]:
                primitivegroup_elt = PrimitiveGroup()
                primitivegroup_elt.ParseFromDict(primitivegroup_dict)
                self.primitivegroup.append(primitivegroup_elt)
        except KeyError:
            pass
        try:
            self.granularity = d["granularity"]
        except KeyError:
            pass
        try:
            self.date_granularity = d["date_granularity"]
        except KeyError:
            pass
        try:
            self.lat_offset = d["lat_offset"]
        except KeyError:
            pass
        try:
            self.lon_offset = d["lon_offset"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        stringtable_dict = self.stringtable.SerializeToDict()
        if stringtable_dict != {}:
            out["stringtable"] = stringtable_dict
        if len(self.primitivegroup) > 0:
            out["primitivegroup"] = [m.SerializeToDict() for m in self.primitivegroup]
        if self.__field_bitmap0 & 65536 == 65536:
            out["granularity"] = self.granularity
        if self.__field_bitmap0 & 131072 == 131072:
            out["date_granularity"] = self.date_granularity
        if self.__field_bitmap0 & 262144 == 262144:
            out["lat_offset"] = self.lat_offset
        if self.__field_bitmap0 & 524288 == 524288:
            out["lon_offset"] = self.lon_offset

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        stringtable_dict = self.stringtable.SerializePartialToDict()
        if stringtable_dict != {}:
            out["stringtable"] = stringtable_dict
        if len(self.primitivegroup) > 0:
            out["primitivegroup"] = [m.SerializePartialToDict() for m in self.primitivegroup]
        if self.__field_bitmap0 & 65536 == 65536:
            out["granularity"] = self.granularity
        if self.__field_bitmap0 & 131072 == 131072:
            out["date_granularity"] = self.date_granularity
        if self.__field_bitmap0 & 262144 == 262144:
            out["lat_offset"] = self.lat_offset
        if self.__field_bitmap0 & 524288 == 524288:
            out["lon_offset"] = self.lon_offset

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'stringtable', self.stringtable
        yield 'primitivegroup', self.primitivegroup
        yield 'granularity', self.granularity
        yield 'date_granularity', self.date_granularity
        yield 'lat_offset', self.lat_offset
        yield 'lon_offset', self.lon_offset

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'stringtable'
        yield 'primitivegroup'
        yield 'granularity'
        yield 'date_granularity'
        yield 'lat_offset'
        yield 'lon_offset'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.stringtable
        yield self.primitivegroup
        yield self.granularity
        yield self.date_granularity
        yield self.lat_offset
        yield self.lon_offset

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.stringtable = value
        yield setter
        def setter(value):
            self.primitivegroup = value
        yield setter
        def setter(value):
            self.granularity = value
        yield setter
        def setter(value):
            self.date_granularity = value
        yield setter
        def setter(value):
            self.lat_offset = value
        yield setter
        def setter(value):
            self.lon_offset = value
        yield setter

    


cdef class PrimitiveGroup:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._nodes is not None:
            self._nodes._listener = <PyObject *>null_listener
        if self._dense is not None:
            self._dense._listener = <PyObject *>null_listener
        if self._ways is not None:
            self._ways._listener = <PyObject *>null_listener
        if self._relations is not None:
            self._relations._listener = <PyObject *>null_listener
        if self._changesets is not None:
            self._changesets._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('dense',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('nodes','ways','relations','changesets',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = []
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'nodes',
                            'dense',
                            'ways',
                            'relations',
                            'changesets',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        if self._nodes is not None:
            self._nodes._listener = <PyObject *>null_listener
        self._nodes = TypedList.__new__(TypedList)
        self._nodes._list_type = Node
        self._nodes._listener = <PyObject *>self
        if self._dense is not None:
            self._dense._listener = <PyObject *>null_listener
        self._dense = None
        if self._ways is not None:
            self._ways._listener = <PyObject *>null_listener
        self._ways = TypedList.__new__(TypedList)
        self._ways._list_type = Way
        self._ways._listener = <PyObject *>self
        if self._relations is not None:
            self._relations._listener = <PyObject *>null_listener
        self._relations = TypedList.__new__(TypedList)
        self._relations._list_type = Relation
        self._relations._listener = <PyObject *>self
        if self._changesets is not None:
            self._changesets._listener = <PyObject *>null_listener
        self._changesets = TypedList.__new__(TypedList)
        self._changesets._list_type = ChangeSet
        self._changesets._listener = <PyObject *>self
        return

    
    @property
    def nodes(self):
        # lazy init sub messages
        if self._nodes is None:
            self._nodes = Node.__new__(Node)
            self._nodes.reset()
            self._nodes._listener = <PyObject *>self
        return self._nodes

    @nodes.setter
    def nodes(self, value):
        if self._nodes is not None:
            self._nodes._listener = <PyObject *>null_listener
        self._nodes = TypedList.__new__(TypedList)
        self._nodes._list_type = Node
        self._nodes._listener = <PyObject *>self
        for val in value:
            list.append(self._nodes, val)
        self._Modified()
    
    @property
    def dense(self):
        # lazy init sub messages
        if self._dense is None:
            self._dense = DenseNodes.__new__(DenseNodes)
            self._dense.reset()
            self._dense._listener = <PyObject *>self
        return self._dense

    @dense.setter
    def dense(self, value):
        if self._dense is not None:
            self._dense._listener = <PyObject *>null_listener
        self._dense = value
        self._dense._listener = <PyObject *>self
        self._Modified()
    
    @property
    def ways(self):
        # lazy init sub messages
        if self._ways is None:
            self._ways = Way.__new__(Way)
            self._ways.reset()
            self._ways._listener = <PyObject *>self
        return self._ways

    @ways.setter
    def ways(self, value):
        if self._ways is not None:
            self._ways._listener = <PyObject *>null_listener
        self._ways = TypedList.__new__(TypedList)
        self._ways._list_type = Way
        self._ways._listener = <PyObject *>self
        for val in value:
            list.append(self._ways, val)
        self._Modified()
    
    @property
    def relations(self):
        # lazy init sub messages
        if self._relations is None:
            self._relations = Relation.__new__(Relation)
            self._relations.reset()
            self._relations._listener = <PyObject *>self
        return self._relations

    @relations.setter
    def relations(self, value):
        if self._relations is not None:
            self._relations._listener = <PyObject *>null_listener
        self._relations = TypedList.__new__(TypedList)
        self._relations._list_type = Relation
        self._relations._listener = <PyObject *>self
        for val in value:
            list.append(self._relations, val)
        self._Modified()
    
    @property
    def changesets(self):
        # lazy init sub messages
        if self._changesets is None:
            self._changesets = ChangeSet.__new__(ChangeSet)
            self._changesets.reset()
            self._changesets._listener = <PyObject *>self
        return self._changesets

    @changesets.setter
    def changesets(self, value):
        if self._changesets is not None:
            self._changesets._listener = <PyObject *>null_listener
        self._changesets = TypedList.__new__(TypedList)
        self._changesets._list_type = ChangeSet
        self._changesets._listener = <PyObject *>self
        for val in value:
            list.append(self._changesets, val)
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef Node nodes_elt
        cdef Way ways_elt
        cdef Relation relations_elt
        cdef ChangeSet changesets_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # nodes
            if key == 10:
                nodes_elt = Node.__new__(Node)
                nodes_elt.reset()
                field_size = get_varint64(memory, &current_offset)
                if cache:
                    nodes_elt._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += nodes_elt._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
                list.append(self._nodes, nodes_elt)
            # dense
            elif key == 18:
                field_size = get_varint64(memory, &current_offset)
                if self._dense is None:
                    self._dense = DenseNodes.__new__(DenseNodes)
                    self._dense._listener = <PyObject *>self
                self._dense.reset()
                if cache:
                    self._dense._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._dense._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # ways
            elif key == 26:
                ways_elt = Way.__new__(Way)
                ways_elt.reset()
                field_size = get_varint64(memory, &current_offset)
                if cache:
                    ways_elt._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += ways_elt._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
                list.append(self._ways, ways_elt)
            # relations
            elif key == 34:
                relations_elt = Relation.__new__(Relation)
                relations_elt.reset()
                field_size = get_varint64(memory, &current_offset)
                if cache:
                    relations_elt._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += relations_elt._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
                list.append(self._relations, relations_elt)
            # changesets
            elif key == 42:
                changesets_elt = ChangeSet.__new__(ChangeSet)
                changesets_elt.reset()
                field_size = get_varint64(memory, &current_offset)
                if cache:
                    changesets_elt._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += changesets_elt._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
                list.append(self._changesets, changesets_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'nodes':
            if self._nodes is not None:
                self._nodes._listener = <PyObject *>null_listener
            self._nodes = TypedList.__new__(TypedList)
            self._nodes._list_type = Node
            self._nodes._listener = <PyObject *>self
        elif field_name == 'dense':
            if self._dense is not None:
                self._dense._listener = <PyObject *>null_listener
            self._dense = None
        elif field_name == 'ways':
            if self._ways is not None:
                self._ways._listener = <PyObject *>null_listener
            self._ways = TypedList.__new__(TypedList)
            self._ways._list_type = Way
            self._ways._listener = <PyObject *>self
        elif field_name == 'relations':
            if self._relations is not None:
                self._relations._listener = <PyObject *>null_listener
            self._relations = TypedList.__new__(TypedList)
            self._relations._list_type = Relation
            self._relations._listener = <PyObject *>self
        elif field_name == 'changesets':
            if self._changesets is not None:
                self._changesets._listener = <PyObject *>null_listener
            self._changesets = TypedList.__new__(TypedList)
            self._changesets._list_type = ChangeSet
            self._changesets._listener = <PyObject *>self
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, PrimitiveGroup other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (PrimitiveGroup): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'dense':
            return self._dense is not None and self._dense._is_present_in_parent
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """
        cdef int i
        cdef Node nodes_msg
        cdef Way ways_msg
        cdef Relation relations_msg
        cdef ChangeSet changesets_msg

    
        if self._dense is not None and self._dense._is_present_in_parent and not self._dense.IsInitialized():
            return False
        for i in range(len(self._nodes)):
            nodes_msg = <Node>self._nodes[i]
            if not nodes_msg.IsInitialized():
                return False
        for i in range(len(self._ways)):
            ways_msg = <Way>self._ways[i]
            if not ways_msg.IsInitialized():
                return False
        for i in range(len(self._relations)):
            relations_msg = <Relation>self._relations[i]
            if not relations_msg.IsInitialized():
                return False
        for i in range(len(self._changesets)):
            changesets_msg = <ChangeSet>self._changesets[i]
            if not changesets_msg.IsInitialized():
                return False

        return True

    cpdef void MergeFrom(self, PrimitiveGroup other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i
        cdef Node nodes_elt
        cdef Way ways_elt
        cdef Relation relations_elt
        cdef ChangeSet changesets_elt

        if self is other_msg:
            return

    
        for i in range(len(other_msg._nodes)):
            nodes_elt = Node()
            nodes_elt.MergeFrom(other_msg._nodes[i])
            list.append(self._nodes, nodes_elt)
        if other_msg._dense is not None and other_msg._dense._is_present_in_parent:
            if self._dense is None:
                self._dense = DenseNodes.__new__(DenseNodes)
                self._dense.reset()
                self._dense._listener = <PyObject *>self
            self._dense.MergeFrom(other_msg._dense)
        for i in range(len(other_msg._ways)):
            ways_elt = Way()
            ways_elt.MergeFrom(other_msg._ways[i])
            list.append(self._ways, ways_elt)
        for i in range(len(other_msg._relations)):
            relations_elt = Relation()
            relations_elt.MergeFrom(other_msg._relations[i])
            list.append(self._relations, relations_elt)
        for i in range(len(other_msg._changesets)):
            changesets_elt = ChangeSet()
            changesets_elt.MergeFrom(other_msg._changesets[i])
            list.append(self._changesets, changesets_elt)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # nodes
        cdef Node nodes_elt
        cdef bytearray nodes_elt_buf
        for nodes_elt in self._nodes:
            set_varint64(10, buf)
            if nodes_elt._cached_serialization is not None:
                set_varint64(len(nodes_elt._cached_serialization), buf)
                buf += nodes_elt._cached_serialization
            else:
                nodes_elt_buf = bytearray()
                nodes_elt._protobuf_serialize(nodes_elt_buf, cache)
                set_varint64(len(nodes_elt_buf), buf)
                buf += nodes_elt_buf
                if cache:
                    nodes_elt._cached_serialization = bytes(nodes_elt_buf)
        # dense
        cdef bytearray dense_buf
        if self._dense is not None and self._dense._is_present_in_parent:
            set_varint64(18, buf)
            if self._dense._cached_serialization is not None:
                set_varint64(len(self._dense._cached_serialization), buf)
                buf += self._dense._cached_serialization
            else:
                dense_buf = bytearray()
                self._dense._protobuf_serialize(dense_buf, cache)
                set_varint64(len(dense_buf), buf)
                buf += dense_buf
                if cache:
                    self._dense._cached_serialization = bytes(dense_buf)
        # ways
        cdef Way ways_elt
        cdef bytearray ways_elt_buf
        for ways_elt in self._ways:
            set_varint64(26, buf)
            if ways_elt._cached_serialization is not None:
                set_varint64(len(ways_elt._cached_serialization), buf)
                buf += ways_elt._cached_serialization
            else:
                ways_elt_buf = bytearray()
                ways_elt._protobuf_serialize(ways_elt_buf, cache)
                set_varint64(len(ways_elt_buf), buf)
                buf += ways_elt_buf
                if cache:
                    ways_elt._cached_serialization = bytes(ways_elt_buf)
        # relations
        cdef Relation relations_elt
        cdef bytearray relations_elt_buf
        for relations_elt in self._relations:
            set_varint64(34, buf)
            if relations_elt._cached_serialization is not None:
                set_varint64(len(relations_elt._cached_serialization), buf)
                buf += relations_elt._cached_serialization
            else:
                relations_elt_buf = bytearray()
                relations_elt._protobuf_serialize(relations_elt_buf, cache)
                set_varint64(len(relations_elt_buf), buf)
                buf += relations_elt_buf
                if cache:
                    relations_elt._cached_serialization = bytes(relations_elt_buf)
        # changesets
        cdef ChangeSet changesets_elt
        cdef bytearray changesets_elt_buf
        for changesets_elt in self._changesets:
            set_varint64(42, buf)
            if changesets_elt._cached_serialization is not None:
                set_varint64(len(changesets_elt._cached_serialization), buf)
                buf += changesets_elt._cached_serialization
            else:
                changesets_elt_buf = bytearray()
                changesets_elt._protobuf_serialize(changesets_elt_buf, cache)
                set_varint64(len(changesets_elt_buf), buf)
                buf += changesets_elt_buf
                if cache:
                    changesets_elt._cached_serialization = bytes(changesets_elt_buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        cdef int i
        cdef Node nodes_msg
        cdef Way ways_msg
        cdef Relation relations_msg
        cdef ChangeSet changesets_msg

    
        if self._dense is not None and self._dense._is_present_in_parent and not self._dense.IsInitialized():
            raise Exception("Message PrimitiveGroup is missing required field: dense")
        for i in range(len(self._nodes)):
            nodes_msg = <Node>self._nodes[i]
            if not nodes_msg.IsInitialized():
                raise Exception("Message PrimitiveGroup is missing required field: nodes[%d]" % i)
        for i in range(len(self._ways)):
            ways_msg = <Way>self._ways[i]
            if not ways_msg.IsInitialized():
                raise Exception("Message PrimitiveGroup is missing required field: ways[%d]" % i)
        for i in range(len(self._relations)):
            relations_msg = <Relation>self._relations[i]
            if not relations_msg.IsInitialized():
                raise Exception("Message PrimitiveGroup is missing required field: relations[%d]" % i)
        for i in range(len(self._changesets)):
            changesets_msg = <ChangeSet>self._changesets[i]
            if not changesets_msg.IsInitialized():
                raise Exception("Message PrimitiveGroup is missing required field: changesets[%d]" % i)

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            for nodes_dict in d["nodes"]:
                nodes_elt = Node()
                nodes_elt.ParseFromDict(nodes_dict)
                self.nodes.append(nodes_elt)
        except KeyError:
            pass
        try:
            self.dense.ParseFromDict(d["dense"])
        except KeyError:
            pass
        try:
            for ways_dict in d["ways"]:
                ways_elt = Way()
                ways_elt.ParseFromDict(ways_dict)
                self.ways.append(ways_elt)
        except KeyError:
            pass
        try:
            for relations_dict in d["relations"]:
                relations_elt = Relation()
                relations_elt.ParseFromDict(relations_dict)
                self.relations.append(relations_elt)
        except KeyError:
            pass
        try:
            for changesets_dict in d["changesets"]:
                changesets_elt = ChangeSet()
                changesets_elt.ParseFromDict(changesets_dict)
                self.changesets.append(changesets_elt)
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.nodes) > 0:
            out["nodes"] = [m.SerializeToDict() for m in self.nodes]
        dense_dict = self.dense.SerializeToDict()
        if dense_dict != {}:
            out["dense"] = dense_dict
        if len(self.ways) > 0:
            out["ways"] = [m.SerializeToDict() for m in self.ways]
        if len(self.relations) > 0:
            out["relations"] = [m.SerializeToDict() for m in self.relations]
        if len(self.changesets) > 0:
            out["changesets"] = [m.SerializeToDict() for m in self.changesets]

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.nodes) > 0:
            out["nodes"] = [m.SerializePartialToDict() for m in self.nodes]
        dense_dict = self.dense.SerializePartialToDict()
        if dense_dict != {}:
            out["dense"] = dense_dict
        if len(self.ways) > 0:
            out["ways"] = [m.SerializePartialToDict() for m in self.ways]
        if len(self.relations) > 0:
            out["relations"] = [m.SerializePartialToDict() for m in self.relations]
        if len(self.changesets) > 0:
            out["changesets"] = [m.SerializePartialToDict() for m in self.changesets]

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'nodes', self.nodes
        yield 'dense', self.dense
        yield 'ways', self.ways
        yield 'relations', self.relations
        yield 'changesets', self.changesets

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'nodes'
        yield 'dense'
        yield 'ways'
        yield 'relations'
        yield 'changesets'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.nodes
        yield self.dense
        yield self.ways
        yield self.relations
        yield self.changesets

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.nodes = value
        yield setter
        def setter(value):
            self.dense = value
        yield setter
        def setter(value):
            self.ways = value
        yield setter
        def setter(value):
            self.relations = value
        yield setter
        def setter(value):
            self.changesets = value
        yield setter

    


cdef class StringTable:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._s is not None:
            self._s._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('s',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          's',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        if self._s is not None:
            self._s._listener = <PyObject *>null_listener
        self._s = BytesList.__new__(BytesList)
        self._s._listener = <PyObject *>self
        return

    
    @property
    def s(self):
        return self._s

    @s.setter
    def s(self, value):
        if self._s is not None:
            self._s._listener = <PyObject *>null_listener
        self._s = BytesList.__new__(BytesList)
        self._s._listener = <PyObject *>self
        for val in value:
            if isinstance(val, bytes):
                list.append(self._s, val)
            else:
                raise TypeError("%r has type %s, but expected one of: (%s,)" % (val, type(val), bytes))
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef bytes s_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # s
            if key == 10:
                field_size = get_varint64(memory, &current_offset)
                s_elt = memory[current_offset:current_offset + field_size]
                current_offset += <int>field_size
                list.append(self._s, s_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 's':
            self._s._listener = <PyObject *>null_listener
            self._s = BytesList.__new__(BytesList)
            self._s._listener = <PyObject *>self
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, StringTable other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (StringTable): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    

        return True

    cpdef void MergeFrom(self, StringTable other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        self._s += other_msg._s

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # s
        cdef bytes s_elt
        for s_elt in self._s:
            set_varint64(10, buf)
            set_varint64(len(s_elt), buf)
            buf += s_elt

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.s = base64.b64decode(d["s"].encode('utf-8'))
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.s) > 0:
            out["s"] = list(self.s)

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.s) > 0:
            out["s"] = list(self.s)

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 's', self.s

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 's'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.s

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.s = value
        yield setter

    


cdef class Info:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'version',
                          'timestamp',
                          'changeset',
                          'uid',
                          'user_sid',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._version = -1
        self._timestamp = 0
        self._changeset = 0
        self._uid = 0
        self._user_sid = 0
        return

    
    @property
    def version(self):
        return self._version

    @version.setter
    def version(self, value):
        self.__field_bitmap0 |= 1
        self._version = value
        self._Modified()
    
    @property
    def timestamp(self):
        return self._timestamp

    @timestamp.setter
    def timestamp(self, value):
        self.__field_bitmap0 |= 2
        self._timestamp = value
        self._Modified()
    
    @property
    def changeset(self):
        return self._changeset

    @changeset.setter
    def changeset(self, value):
        self.__field_bitmap0 |= 4
        self._changeset = value
        self._Modified()
    
    @property
    def uid(self):
        return self._uid

    @uid.setter
    def uid(self, value):
        self.__field_bitmap0 |= 8
        self._uid = value
        self._Modified()
    
    @property
    def user_sid(self):
        return self._user_sid

    @user_sid.setter
    def user_sid(self, value):
        self.__field_bitmap0 |= 16
        self._user_sid = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # version
            if key == 8:
                self.__field_bitmap0 |= 1
                self._version = get_varint32(memory, &current_offset)
            # timestamp
            elif key == 16:
                self.__field_bitmap0 |= 2
                self._timestamp = get_varint64(memory, &current_offset)
            # changeset
            elif key == 24:
                self.__field_bitmap0 |= 4
                self._changeset = get_varint64(memory, &current_offset)
            # uid
            elif key == 32:
                self.__field_bitmap0 |= 8
                self._uid = get_varint32(memory, &current_offset)
            # user_sid
            elif key == 40:
                self.__field_bitmap0 |= 16
                self._user_sid = get_varint32(memory, &current_offset)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'version':
            self.__field_bitmap0 &= ~1
            self._version = -1
        elif field_name == 'timestamp':
            self.__field_bitmap0 &= ~2
            self._timestamp = 0
        elif field_name == 'changeset':
            self.__field_bitmap0 &= ~4
            self._changeset = 0
        elif field_name == 'uid':
            self.__field_bitmap0 &= ~8
            self._uid = 0
        elif field_name == 'user_sid':
            self.__field_bitmap0 &= ~16
            self._user_sid = 0
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, Info other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (Info): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'version':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'timestamp':
            return self.__field_bitmap0 & 2 == 2
        if field_name == 'changeset':
            return self.__field_bitmap0 & 4 == 4
        if field_name == 'uid':
            return self.__field_bitmap0 & 8 == 8
        if field_name == 'user_sid':
            return self.__field_bitmap0 & 16 == 16
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    

        return True

    cpdef void MergeFrom(self, Info other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._version = other_msg._version
            self.__field_bitmap0 |= 1
        if other_msg.__field_bitmap0 & 2 == 2:
            self._timestamp = other_msg._timestamp
            self.__field_bitmap0 |= 2
        if other_msg.__field_bitmap0 & 4 == 4:
            self._changeset = other_msg._changeset
            self.__field_bitmap0 |= 4
        if other_msg.__field_bitmap0 & 8 == 8:
            self._uid = other_msg._uid
            self.__field_bitmap0 |= 8
        if other_msg.__field_bitmap0 & 16 == 16:
            self._user_sid = other_msg._user_sid
            self.__field_bitmap0 |= 16

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        # version
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_varint32(self._version, buf)
        # timestamp
        if self.__field_bitmap0 & 2 == 2:
            set_varint64(16, buf)
            set_varint64(self._timestamp, buf)
        # changeset
        if self.__field_bitmap0 & 4 == 4:
            set_varint64(24, buf)
            set_varint64(self._changeset, buf)
        # uid
        if self.__field_bitmap0 & 8 == 8:
            set_varint64(32, buf)
            set_varint32(self._uid, buf)
        # user_sid
        if self.__field_bitmap0 & 16 == 16:
            set_varint64(40, buf)
            set_varint32(self._user_sid, buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.version = d["version"]
        except KeyError:
            pass
        try:
            self.timestamp = d["timestamp"]
        except KeyError:
            pass
        try:
            self.changeset = d["changeset"]
        except KeyError:
            pass
        try:
            self.uid = d["uid"]
        except KeyError:
            pass
        try:
            self.user_sid = d["user_sid"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["version"] = self.version
        if self.__field_bitmap0 & 2 == 2:
            out["timestamp"] = self.timestamp
        if self.__field_bitmap0 & 4 == 4:
            out["changeset"] = self.changeset
        if self.__field_bitmap0 & 8 == 8:
            out["uid"] = self.uid
        if self.__field_bitmap0 & 16 == 16:
            out["user_sid"] = self.user_sid

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["version"] = self.version
        if self.__field_bitmap0 & 2 == 2:
            out["timestamp"] = self.timestamp
        if self.__field_bitmap0 & 4 == 4:
            out["changeset"] = self.changeset
        if self.__field_bitmap0 & 8 == 8:
            out["uid"] = self.uid
        if self.__field_bitmap0 & 16 == 16:
            out["user_sid"] = self.user_sid

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'version', self.version
        yield 'timestamp', self.timestamp
        yield 'changeset', self.changeset
        yield 'uid', self.uid
        yield 'user_sid', self.user_sid

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'version'
        yield 'timestamp'
        yield 'changeset'
        yield 'uid'
        yield 'user_sid'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.version
        yield self.timestamp
        yield self.changeset
        yield self.uid
        yield self.user_sid

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.version = value
        yield setter
        def setter(value):
            self.timestamp = value
        yield setter
        def setter(value):
            self.changeset = value
        yield setter
        def setter(value):
            self.uid = value
        yield setter
        def setter(value):
            self.user_sid = value
        yield setter

    


cdef class DenseInfo:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._version is not None:
            self._version._listener = <PyObject *>null_listener
        if self._timestamp is not None:
            self._timestamp._listener = <PyObject *>null_listener
        if self._changeset is not None:
            self._changeset._listener = <PyObject *>null_listener
        if self._uid is not None:
            self._uid._listener = <PyObject *>null_listener
        if self._user_sid is not None:
            self._user_sid._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('version','timestamp','changeset','uid','user_sid',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'version',
                          'timestamp',
                          'changeset',
                          'uid',
                          'user_sid',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        if self._version is not None:
            self._version._listener = <PyObject *>null_listener
        self._version = Int32List.__new__(Int32List)
        self._version._listener = <PyObject *>self
        if self._timestamp is not None:
            self._timestamp._listener = <PyObject *>null_listener
        self._timestamp = Int64List.__new__(Int64List)
        self._timestamp._listener = <PyObject *>self
        if self._changeset is not None:
            self._changeset._listener = <PyObject *>null_listener
        self._changeset = Int64List.__new__(Int64List)
        self._changeset._listener = <PyObject *>self
        if self._uid is not None:
            self._uid._listener = <PyObject *>null_listener
        self._uid = Int32List.__new__(Int32List)
        self._uid._listener = <PyObject *>self
        if self._user_sid is not None:
            self._user_sid._listener = <PyObject *>null_listener
        self._user_sid = Int32List.__new__(Int32List)
        self._user_sid._listener = <PyObject *>self
        return

    
    @property
    def version(self):
        return self._version

    @version.setter
    def version(self, value):
        if self._version is not None:
            self._version._listener = <PyObject *>null_listener
        cdef int32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._version = Int32List(memview.size, listener=self)
            for i in range(memview.size):
                self._version.append(memview[i])
            return
        self._version = Int32List(listener=self)
        for val in value:
            self._version.append(val)
        self._Modified()
    
    @property
    def timestamp(self):
        return self._timestamp

    @timestamp.setter
    def timestamp(self, value):
        if self._timestamp is not None:
            self._timestamp._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._timestamp = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._timestamp.append(memview[i])
            return
        self._timestamp = Int64List(listener=self)
        for val in value:
            self._timestamp.append(val)
        self._Modified()
    
    @property
    def changeset(self):
        return self._changeset

    @changeset.setter
    def changeset(self, value):
        if self._changeset is not None:
            self._changeset._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._changeset = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._changeset.append(memview[i])
            return
        self._changeset = Int64List(listener=self)
        for val in value:
            self._changeset.append(val)
        self._Modified()
    
    @property
    def uid(self):
        return self._uid

    @uid.setter
    def uid(self, value):
        if self._uid is not None:
            self._uid._listener = <PyObject *>null_listener
        cdef int32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._uid = Int32List(memview.size, listener=self)
            for i in range(memview.size):
                self._uid.append(memview[i])
            return
        self._uid = Int32List(listener=self)
        for val in value:
            self._uid.append(val)
        self._Modified()
    
    @property
    def user_sid(self):
        return self._user_sid

    @user_sid.setter
    def user_sid(self, value):
        if self._user_sid is not None:
            self._user_sid._listener = <PyObject *>null_listener
        cdef int32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._user_sid = Int32List(memview.size, listener=self)
            for i in range(memview.size):
                self._user_sid.append(memview[i])
            return
        self._user_sid = Int32List(listener=self)
        for val in value:
            self._user_sid.append(val)
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t version_marker
        cdef int32_t version_elt
        cdef int64_t timestamp_marker
        cdef int64_t timestamp_elt
        cdef int64_t changeset_marker
        cdef int64_t changeset_elt
        cdef int64_t uid_marker
        cdef int32_t uid_elt
        cdef int64_t user_sid_marker
        cdef int32_t user_sid_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # version
            if key == 10:
                version_marker = get_varint64(memory, &current_offset)
                version_marker += current_offset

                while current_offset < <int>version_marker:
                    version_elt = get_varint32(memory, &current_offset)
                    self._version._append(version_elt)
            # timestamp
            elif key == 18:
                timestamp_marker = get_varint64(memory, &current_offset)
                timestamp_marker += current_offset

                while current_offset < <int>timestamp_marker:
                    timestamp_elt = get_signed_varint64(memory, &current_offset)
                    self._timestamp._append(timestamp_elt)
            # changeset
            elif key == 26:
                changeset_marker = get_varint64(memory, &current_offset)
                changeset_marker += current_offset

                while current_offset < <int>changeset_marker:
                    changeset_elt = get_signed_varint64(memory, &current_offset)
                    self._changeset._append(changeset_elt)
            # uid
            elif key == 34:
                uid_marker = get_varint64(memory, &current_offset)
                uid_marker += current_offset

                while current_offset < <int>uid_marker:
                    uid_elt = get_signed_varint32(memory, &current_offset)
                    self._uid._append(uid_elt)
            # user_sid
            elif key == 42:
                user_sid_marker = get_varint64(memory, &current_offset)
                user_sid_marker += current_offset

                while current_offset < <int>user_sid_marker:
                    user_sid_elt = get_signed_varint32(memory, &current_offset)
                    self._user_sid._append(user_sid_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'version':
            self._version._listener = <PyObject *>null_listener
            self._version = Int32List.__new__(Int32List)
            self._version._listener = <PyObject *>self
        elif field_name == 'timestamp':
            self._timestamp._listener = <PyObject *>null_listener
            self._timestamp = Int64List.__new__(Int64List)
            self._timestamp._listener = <PyObject *>self
        elif field_name == 'changeset':
            self._changeset._listener = <PyObject *>null_listener
            self._changeset = Int64List.__new__(Int64List)
            self._changeset._listener = <PyObject *>self
        elif field_name == 'uid':
            self._uid._listener = <PyObject *>null_listener
            self._uid = Int32List.__new__(Int32List)
            self._uid._listener = <PyObject *>self
        elif field_name == 'user_sid':
            self._user_sid._listener = <PyObject *>null_listener
            self._user_sid = Int32List.__new__(Int32List)
            self._user_sid._listener = <PyObject *>self
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, DenseInfo other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (DenseInfo): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    

        return True

    cpdef void MergeFrom(self, DenseInfo other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        self._version.extend(other_msg._version)
        self._timestamp.extend(other_msg._timestamp)
        self._changeset.extend(other_msg._changeset)
        self._uid.extend(other_msg._uid)
        self._user_sid.extend(other_msg._user_sid)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # version
        cdef int32_t version_elt
        cdef bytearray version_buf = bytearray()
        length = len(self._version)
        if length > 0:
            set_varint64(10, buf)
            for version_elt in self._version:
                set_varint32(version_elt, version_buf)

            set_varint64(len(version_buf), buf)
            buf += version_buf
        # timestamp
        cdef int64_t timestamp_elt
        cdef bytearray timestamp_buf = bytearray()
        length = len(self._timestamp)
        if length > 0:
            set_varint64(18, buf)
            for timestamp_elt in self._timestamp:
                set_signed_varint64(timestamp_elt, timestamp_buf)

            set_varint64(len(timestamp_buf), buf)
            buf += timestamp_buf
        # changeset
        cdef int64_t changeset_elt
        cdef bytearray changeset_buf = bytearray()
        length = len(self._changeset)
        if length > 0:
            set_varint64(26, buf)
            for changeset_elt in self._changeset:
                set_signed_varint64(changeset_elt, changeset_buf)

            set_varint64(len(changeset_buf), buf)
            buf += changeset_buf
        # uid
        cdef int32_t uid_elt
        cdef bytearray uid_buf = bytearray()
        length = len(self._uid)
        if length > 0:
            set_varint64(34, buf)
            for uid_elt in self._uid:
                set_signed_varint32(uid_elt, uid_buf)

            set_varint64(len(uid_buf), buf)
            buf += uid_buf
        # user_sid
        cdef int32_t user_sid_elt
        cdef bytearray user_sid_buf = bytearray()
        length = len(self._user_sid)
        if length > 0:
            set_varint64(42, buf)
            for user_sid_elt in self._user_sid:
                set_signed_varint32(user_sid_elt, user_sid_buf)

            set_varint64(len(user_sid_buf), buf)
            buf += user_sid_buf

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.version = d["version"]
        except KeyError:
            pass
        try:
            self.timestamp = d["timestamp"]
        except KeyError:
            pass
        try:
            self.changeset = d["changeset"]
        except KeyError:
            pass
        try:
            self.uid = d["uid"]
        except KeyError:
            pass
        try:
            self.user_sid = d["user_sid"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.version) > 0:
            out["version"] = list(self.version)
        if len(self.timestamp) > 0:
            out["timestamp"] = list(self.timestamp)
        if len(self.changeset) > 0:
            out["changeset"] = list(self.changeset)
        if len(self.uid) > 0:
            out["uid"] = list(self.uid)
        if len(self.user_sid) > 0:
            out["user_sid"] = list(self.user_sid)

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.version) > 0:
            out["version"] = list(self.version)
        if len(self.timestamp) > 0:
            out["timestamp"] = list(self.timestamp)
        if len(self.changeset) > 0:
            out["changeset"] = list(self.changeset)
        if len(self.uid) > 0:
            out["uid"] = list(self.uid)
        if len(self.user_sid) > 0:
            out["user_sid"] = list(self.user_sid)

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'version', self.version
        yield 'timestamp', self.timestamp
        yield 'changeset', self.changeset
        yield 'uid', self.uid
        yield 'user_sid', self.user_sid

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'version'
        yield 'timestamp'
        yield 'changeset'
        yield 'uid'
        yield 'user_sid'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.version
        yield self.timestamp
        yield self.changeset
        yield self.uid
        yield self.user_sid

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.version = value
        yield setter
        def setter(value):
            self.timestamp = value
        yield setter
        def setter(value):
            self.changeset = value
        yield setter
        def setter(value):
            self.uid = value
        yield setter
        def setter(value):
            self.user_sid = value
        yield setter

    


cdef class ChangeSet:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'id',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._id = 0
        return

    
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, value):
        self.__field_bitmap0 |= 1
        self._id = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # id
            if key == 8:
                self.__field_bitmap0 |= 1
                self._id = get_varint64(memory, &current_offset)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'id':
            self.__field_bitmap0 &= ~1
            self._id = 0
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, ChangeSet other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (ChangeSet): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'id':
            return self.__field_bitmap0 & 1 == 1
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self.__field_bitmap0 & 1 != 1:
            return False

        return True

    cpdef void MergeFrom(self, ChangeSet other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._id = other_msg._id
            self.__field_bitmap0 |= 1

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        # id
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_varint64(self._id, buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.id = d["id"]
        except KeyError:
            pass

        self._Modified()
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'id', self.id

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'id'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.id

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.id = value
        yield setter

    


cdef class Node:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('info',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('keys','vals',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'id',
                          'keys',
                          'vals',
                          'lat',
                          'lon',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'info',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._id = 0
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        self._keys = Uint32List.__new__(Uint32List)
        self._keys._listener = <PyObject *>self
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        self._vals = Uint32List.__new__(Uint32List)
        self._vals._listener = <PyObject *>self
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        self._info = None
        self._lat = 0
        self._lon = 0
        return

    
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, value):
        self.__field_bitmap0 |= 1
        self._id = value
        self._Modified()
    
    @property
    def keys(self):
        return self._keys

    @keys.setter
    def keys(self, value):
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        cdef uint32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._keys = Uint32List(memview.size, listener=self)
            for i in range(memview.size):
                self._keys.append(memview[i])
            return
        self._keys = Uint32List(listener=self)
        for val in value:
            self._keys.append(val)
        self._Modified()
    
    @property
    def vals(self):
        return self._vals

    @vals.setter
    def vals(self, value):
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        cdef uint32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._vals = Uint32List(memview.size, listener=self)
            for i in range(memview.size):
                self._vals.append(memview[i])
            return
        self._vals = Uint32List(listener=self)
        for val in value:
            self._vals.append(val)
        self._Modified()
    
    @property
    def info(self):
        # lazy init sub messages
        if self._info is None:
            self._info = Info.__new__(Info)
            self._info.reset()
            self._info._listener = <PyObject *>self
        return self._info

    @info.setter
    def info(self, value):
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        self._info = value
        self._info._listener = <PyObject *>self
        self._Modified()
    
    @property
    def lat(self):
        return self._lat

    @lat.setter
    def lat(self, value):
        self.__field_bitmap0 |= 128
        self._lat = value
        self._Modified()
    
    @property
    def lon(self):
        return self._lon

    @lon.setter
    def lon(self, value):
        self.__field_bitmap0 |= 256
        self._lon = value
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef int64_t keys_marker
        cdef uint32_t keys_elt
        cdef int64_t vals_marker
        cdef uint32_t vals_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # id
            if key == 8:
                self.__field_bitmap0 |= 1
                self._id = get_signed_varint64(memory, &current_offset)
            # keys
            elif key == 18:
                keys_marker = get_varint64(memory, &current_offset)
                keys_marker += current_offset

                while current_offset < <int>keys_marker:
                    keys_elt = get_varint32(memory, &current_offset)
                    self._keys._append(keys_elt)
            # vals
            elif key == 26:
                vals_marker = get_varint64(memory, &current_offset)
                vals_marker += current_offset

                while current_offset < <int>vals_marker:
                    vals_elt = get_varint32(memory, &current_offset)
                    self._vals._append(vals_elt)
            # info
            elif key == 34:
                field_size = get_varint64(memory, &current_offset)
                if self._info is None:
                    self._info = Info.__new__(Info)
                    self._info._listener = <PyObject *>self
                self._info.reset()
                if cache:
                    self._info._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._info._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # lat
            elif key == 64:
                self.__field_bitmap0 |= 128
                self._lat = get_signed_varint64(memory, &current_offset)
            # lon
            elif key == 72:
                self.__field_bitmap0 |= 256
                self._lon = get_signed_varint64(memory, &current_offset)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'id':
            self.__field_bitmap0 &= ~1
            self._id = 0
        elif field_name == 'keys':
            self._keys._listener = <PyObject *>null_listener
            self._keys = Uint32List.__new__(Uint32List)
            self._keys._listener = <PyObject *>self
        elif field_name == 'vals':
            self._vals._listener = <PyObject *>null_listener
            self._vals = Uint32List.__new__(Uint32List)
            self._vals._listener = <PyObject *>self
        elif field_name == 'info':
            if self._info is not None:
                self._info._listener = <PyObject *>null_listener
            self._info = None
        elif field_name == 'lat':
            self.__field_bitmap0 &= ~128
            self._lat = 0
        elif field_name == 'lon':
            self.__field_bitmap0 &= ~256
            self._lon = 0
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, Node other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (Node): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'id':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'info':
            return self._info is not None and self._info._is_present_in_parent
        if field_name == 'lat':
            return self.__field_bitmap0 & 128 == 128
        if field_name == 'lon':
            return self.__field_bitmap0 & 256 == 256
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self.__field_bitmap0 & 1 != 1:
            return False
        if self.__field_bitmap0 & 128 != 128:
            return False
        if self.__field_bitmap0 & 256 != 256:
            return False
        if self._info is not None and self._info._is_present_in_parent and not self._info.IsInitialized():
            return False

        return True

    cpdef void MergeFrom(self, Node other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._id = other_msg._id
            self.__field_bitmap0 |= 1
        self._keys.extend(other_msg._keys)
        self._vals.extend(other_msg._vals)
        if other_msg._info is not None and other_msg._info._is_present_in_parent:
            if self._info is None:
                self._info = Info.__new__(Info)
                self._info.reset()
                self._info._listener = <PyObject *>self
            self._info.MergeFrom(other_msg._info)
        if other_msg.__field_bitmap0 & 128 == 128:
            self._lat = other_msg._lat
            self.__field_bitmap0 |= 128
        if other_msg.__field_bitmap0 & 256 == 256:
            self._lon = other_msg._lon
            self.__field_bitmap0 |= 256

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # id
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_signed_varint64(self._id, buf)
        # keys
        cdef uint32_t keys_elt
        cdef bytearray keys_buf = bytearray()
        length = len(self._keys)
        if length > 0:
            set_varint64(18, buf)
            for keys_elt in self._keys:
                set_varint32(keys_elt, keys_buf)

            set_varint64(len(keys_buf), buf)
            buf += keys_buf
        # vals
        cdef uint32_t vals_elt
        cdef bytearray vals_buf = bytearray()
        length = len(self._vals)
        if length > 0:
            set_varint64(26, buf)
            for vals_elt in self._vals:
                set_varint32(vals_elt, vals_buf)

            set_varint64(len(vals_buf), buf)
            buf += vals_buf
        # info
        cdef bytearray info_buf
        if self._info is not None and self._info._is_present_in_parent:
            set_varint64(34, buf)
            if self._info._cached_serialization is not None:
                set_varint64(len(self._info._cached_serialization), buf)
                buf += self._info._cached_serialization
            else:
                info_buf = bytearray()
                self._info._protobuf_serialize(info_buf, cache)
                set_varint64(len(info_buf), buf)
                buf += info_buf
                if cache:
                    self._info._cached_serialization = bytes(info_buf)
        # lat
        if self.__field_bitmap0 & 128 == 128:
            set_varint64(64, buf)
            set_signed_varint64(self._lat, buf)
        # lon
        if self.__field_bitmap0 & 256 == 256:
            set_varint64(72, buf)
            set_signed_varint64(self._lon, buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self.__field_bitmap0 & 128 != 128:
            raise Exception("required field 'lat' not initialized and does not have default")
        if self.__field_bitmap0 & 256 != 256:
            raise Exception("required field 'lon' not initialized and does not have default")
        if self._info is not None and self._info._is_present_in_parent and not self._info.IsInitialized():
            raise Exception("Message Node is missing required field: info")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.id = d["id"]
        except KeyError:
            pass
        try:
            self.keys = d["keys"]
        except KeyError:
            pass
        try:
            self.vals = d["vals"]
        except KeyError:
            pass
        try:
            self.info.ParseFromDict(d["info"])
        except KeyError:
            pass
        try:
            self.lat = d["lat"]
        except KeyError:
            pass
        try:
            self.lon = d["lon"]
        except KeyError:
            pass

        self._Modified()
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self.__field_bitmap0 & 128 != 128:
            raise Exception("required field 'lat' not initialized and does not have default")
        if self.__field_bitmap0 & 256 != 256:
            raise Exception("required field 'lon' not initialized and does not have default")

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self.__field_bitmap0 & 128 != 128:
            raise Exception("required field 'lat' not initialized and does not have default")
        if self.__field_bitmap0 & 256 != 256:
            raise Exception("required field 'lon' not initialized and does not have default")
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if len(self.keys) > 0:
            out["keys"] = list(self.keys)
        if len(self.vals) > 0:
            out["vals"] = list(self.vals)
        info_dict = self.info.SerializeToDict()
        if info_dict != {}:
            out["info"] = info_dict
        if self.__field_bitmap0 & 128 == 128:
            out["lat"] = self.lat
        if self.__field_bitmap0 & 256 == 256:
            out["lon"] = self.lon

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if len(self.keys) > 0:
            out["keys"] = list(self.keys)
        if len(self.vals) > 0:
            out["vals"] = list(self.vals)
        info_dict = self.info.SerializePartialToDict()
        if info_dict != {}:
            out["info"] = info_dict
        if self.__field_bitmap0 & 128 == 128:
            out["lat"] = self.lat
        if self.__field_bitmap0 & 256 == 256:
            out["lon"] = self.lon

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'id', self.id
        yield 'keys', self.keys
        yield 'vals', self.vals
        yield 'info', self.info
        yield 'lat', self.lat
        yield 'lon', self.lon

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'id'
        yield 'keys'
        yield 'vals'
        yield 'info'
        yield 'lat'
        yield 'lon'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.id
        yield self.keys
        yield self.vals
        yield self.info
        yield self.lat
        yield self.lon

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.id = value
        yield setter
        def setter(value):
            self.keys = value
        yield setter
        def setter(value):
            self.vals = value
        yield setter
        def setter(value):
            self.info = value
        yield setter
        def setter(value):
            self.lat = value
        yield setter
        def setter(value):
            self.lon = value
        yield setter

    


cdef class DenseNodes:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._id is not None:
            self._id._listener = <PyObject *>null_listener
        if self._denseinfo is not None:
            self._denseinfo._listener = <PyObject *>null_listener
        if self._lat is not None:
            self._lat._listener = <PyObject *>null_listener
        if self._lon is not None:
            self._lon._listener = <PyObject *>null_listener
        if self._keys_vals is not None:
            self._keys_vals._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('denseinfo',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('id','lat','lon','keys_vals',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'id',
                          'lat',
                          'lon',
                          'keys_vals',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'denseinfo',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        if self._id is not None:
            self._id._listener = <PyObject *>null_listener
        self._id = Int64List.__new__(Int64List)
        self._id._listener = <PyObject *>self
        if self._denseinfo is not None:
            self._denseinfo._listener = <PyObject *>null_listener
        self._denseinfo = None
        if self._lat is not None:
            self._lat._listener = <PyObject *>null_listener
        self._lat = Int64List.__new__(Int64List)
        self._lat._listener = <PyObject *>self
        if self._lon is not None:
            self._lon._listener = <PyObject *>null_listener
        self._lon = Int64List.__new__(Int64List)
        self._lon._listener = <PyObject *>self
        if self._keys_vals is not None:
            self._keys_vals._listener = <PyObject *>null_listener
        self._keys_vals = Int32List.__new__(Int32List)
        self._keys_vals._listener = <PyObject *>self
        return

    
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, value):
        if self._id is not None:
            self._id._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._id = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._id.append(memview[i])
            return
        self._id = Int64List(listener=self)
        for val in value:
            self._id.append(val)
        self._Modified()
    
    @property
    def denseinfo(self):
        # lazy init sub messages
        if self._denseinfo is None:
            self._denseinfo = DenseInfo.__new__(DenseInfo)
            self._denseinfo.reset()
            self._denseinfo._listener = <PyObject *>self
        return self._denseinfo

    @denseinfo.setter
    def denseinfo(self, value):
        if self._denseinfo is not None:
            self._denseinfo._listener = <PyObject *>null_listener
        self._denseinfo = value
        self._denseinfo._listener = <PyObject *>self
        self._Modified()
    
    @property
    def lat(self):
        return self._lat

    @lat.setter
    def lat(self, value):
        if self._lat is not None:
            self._lat._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._lat = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._lat.append(memview[i])
            return
        self._lat = Int64List(listener=self)
        for val in value:
            self._lat.append(val)
        self._Modified()
    
    @property
    def lon(self):
        return self._lon

    @lon.setter
    def lon(self, value):
        if self._lon is not None:
            self._lon._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._lon = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._lon.append(memview[i])
            return
        self._lon = Int64List(listener=self)
        for val in value:
            self._lon.append(val)
        self._Modified()
    
    @property
    def keys_vals(self):
        return self._keys_vals

    @keys_vals.setter
    def keys_vals(self, value):
        if self._keys_vals is not None:
            self._keys_vals._listener = <PyObject *>null_listener
        cdef int32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._keys_vals = Int32List(memview.size, listener=self)
            for i in range(memview.size):
                self._keys_vals.append(memview[i])
            return
        self._keys_vals = Int32List(listener=self)
        for val in value:
            self._keys_vals.append(val)
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef int64_t id_marker
        cdef int64_t id_elt
        cdef int64_t lat_marker
        cdef int64_t lat_elt
        cdef int64_t lon_marker
        cdef int64_t lon_elt
        cdef int64_t keys_vals_marker
        cdef int32_t keys_vals_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # id
            if key == 10:
                id_marker = get_varint64(memory, &current_offset)
                id_marker += current_offset

                while current_offset < <int>id_marker:
                    id_elt = get_signed_varint64(memory, &current_offset)
                    self._id._append(id_elt)
            # denseinfo
            elif key == 42:
                field_size = get_varint64(memory, &current_offset)
                if self._denseinfo is None:
                    self._denseinfo = DenseInfo.__new__(DenseInfo)
                    self._denseinfo._listener = <PyObject *>self
                self._denseinfo.reset()
                if cache:
                    self._denseinfo._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._denseinfo._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # lat
            elif key == 66:
                lat_marker = get_varint64(memory, &current_offset)
                lat_marker += current_offset

                while current_offset < <int>lat_marker:
                    lat_elt = get_signed_varint64(memory, &current_offset)
                    self._lat._append(lat_elt)
            # lon
            elif key == 74:
                lon_marker = get_varint64(memory, &current_offset)
                lon_marker += current_offset

                while current_offset < <int>lon_marker:
                    lon_elt = get_signed_varint64(memory, &current_offset)
                    self._lon._append(lon_elt)
            # keys_vals
            elif key == 82:
                keys_vals_marker = get_varint64(memory, &current_offset)
                keys_vals_marker += current_offset

                while current_offset < <int>keys_vals_marker:
                    keys_vals_elt = get_varint32(memory, &current_offset)
                    self._keys_vals._append(keys_vals_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'id':
            self._id._listener = <PyObject *>null_listener
            self._id = Int64List.__new__(Int64List)
            self._id._listener = <PyObject *>self
        elif field_name == 'denseinfo':
            if self._denseinfo is not None:
                self._denseinfo._listener = <PyObject *>null_listener
            self._denseinfo = None
        elif field_name == 'lat':
            self._lat._listener = <PyObject *>null_listener
            self._lat = Int64List.__new__(Int64List)
            self._lat._listener = <PyObject *>self
        elif field_name == 'lon':
            self._lon._listener = <PyObject *>null_listener
            self._lon = Int64List.__new__(Int64List)
            self._lon._listener = <PyObject *>self
        elif field_name == 'keys_vals':
            self._keys_vals._listener = <PyObject *>null_listener
            self._keys_vals = Int32List.__new__(Int32List)
            self._keys_vals._listener = <PyObject *>self
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, DenseNodes other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (DenseNodes): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'denseinfo':
            return self._denseinfo is not None and self._denseinfo._is_present_in_parent
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self._denseinfo is not None and self._denseinfo._is_present_in_parent and not self._denseinfo.IsInitialized():
            return False

        return True

    cpdef void MergeFrom(self, DenseNodes other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        self._id.extend(other_msg._id)
        if other_msg._denseinfo is not None and other_msg._denseinfo._is_present_in_parent:
            if self._denseinfo is None:
                self._denseinfo = DenseInfo.__new__(DenseInfo)
                self._denseinfo.reset()
                self._denseinfo._listener = <PyObject *>self
            self._denseinfo.MergeFrom(other_msg._denseinfo)
        self._lat.extend(other_msg._lat)
        self._lon.extend(other_msg._lon)
        self._keys_vals.extend(other_msg._keys_vals)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # id
        cdef int64_t id_elt
        cdef bytearray id_buf = bytearray()
        length = len(self._id)
        if length > 0:
            set_varint64(10, buf)
            for id_elt in self._id:
                set_signed_varint64(id_elt, id_buf)

            set_varint64(len(id_buf), buf)
            buf += id_buf
        # denseinfo
        cdef bytearray denseinfo_buf
        if self._denseinfo is not None and self._denseinfo._is_present_in_parent:
            set_varint64(42, buf)
            if self._denseinfo._cached_serialization is not None:
                set_varint64(len(self._denseinfo._cached_serialization), buf)
                buf += self._denseinfo._cached_serialization
            else:
                denseinfo_buf = bytearray()
                self._denseinfo._protobuf_serialize(denseinfo_buf, cache)
                set_varint64(len(denseinfo_buf), buf)
                buf += denseinfo_buf
                if cache:
                    self._denseinfo._cached_serialization = bytes(denseinfo_buf)
        # lat
        cdef int64_t lat_elt
        cdef bytearray lat_buf = bytearray()
        length = len(self._lat)
        if length > 0:
            set_varint64(66, buf)
            for lat_elt in self._lat:
                set_signed_varint64(lat_elt, lat_buf)

            set_varint64(len(lat_buf), buf)
            buf += lat_buf
        # lon
        cdef int64_t lon_elt
        cdef bytearray lon_buf = bytearray()
        length = len(self._lon)
        if length > 0:
            set_varint64(74, buf)
            for lon_elt in self._lon:
                set_signed_varint64(lon_elt, lon_buf)

            set_varint64(len(lon_buf), buf)
            buf += lon_buf
        # keys_vals
        cdef int32_t keys_vals_elt
        cdef bytearray keys_vals_buf = bytearray()
        length = len(self._keys_vals)
        if length > 0:
            set_varint64(82, buf)
            for keys_vals_elt in self._keys_vals:
                set_varint32(keys_vals_elt, keys_vals_buf)

            set_varint64(len(keys_vals_buf), buf)
            buf += keys_vals_buf

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self._denseinfo is not None and self._denseinfo._is_present_in_parent and not self._denseinfo.IsInitialized():
            raise Exception("Message DenseNodes is missing required field: denseinfo")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.id = d["id"]
        except KeyError:
            pass
        try:
            self.denseinfo.ParseFromDict(d["denseinfo"])
        except KeyError:
            pass
        try:
            self.lat = d["lat"]
        except KeyError:
            pass
        try:
            self.lon = d["lon"]
        except KeyError:
            pass
        try:
            self.keys_vals = d["keys_vals"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.id) > 0:
            out["id"] = list(self.id)
        denseinfo_dict = self.denseinfo.SerializeToDict()
        if denseinfo_dict != {}:
            out["denseinfo"] = denseinfo_dict
        if len(self.lat) > 0:
            out["lat"] = list(self.lat)
        if len(self.lon) > 0:
            out["lon"] = list(self.lon)
        if len(self.keys_vals) > 0:
            out["keys_vals"] = list(self.keys_vals)

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if len(self.id) > 0:
            out["id"] = list(self.id)
        denseinfo_dict = self.denseinfo.SerializePartialToDict()
        if denseinfo_dict != {}:
            out["denseinfo"] = denseinfo_dict
        if len(self.lat) > 0:
            out["lat"] = list(self.lat)
        if len(self.lon) > 0:
            out["lon"] = list(self.lon)
        if len(self.keys_vals) > 0:
            out["keys_vals"] = list(self.keys_vals)

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'id', self.id
        yield 'denseinfo', self.denseinfo
        yield 'lat', self.lat
        yield 'lon', self.lon
        yield 'keys_vals', self.keys_vals

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'id'
        yield 'denseinfo'
        yield 'lat'
        yield 'lon'
        yield 'keys_vals'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.id
        yield self.denseinfo
        yield self.lat
        yield self.lon
        yield self.keys_vals

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.id = value
        yield setter
        def setter(value):
            self.denseinfo = value
        yield setter
        def setter(value):
            self.lat = value
        yield setter
        def setter(value):
            self.lon = value
        yield setter
        def setter(value):
            self.keys_vals = value
        yield setter

    


cdef class Way:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        if self._refs is not None:
            self._refs._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('info',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('keys','vals','refs',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'id',
                          'keys',
                          'vals',
                          'refs',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'info',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._id = 0
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        self._keys = Uint32List.__new__(Uint32List)
        self._keys._listener = <PyObject *>self
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        self._vals = Uint32List.__new__(Uint32List)
        self._vals._listener = <PyObject *>self
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        self._info = None
        if self._refs is not None:
            self._refs._listener = <PyObject *>null_listener
        self._refs = Int64List.__new__(Int64List)
        self._refs._listener = <PyObject *>self
        return

    
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, value):
        self.__field_bitmap0 |= 1
        self._id = value
        self._Modified()
    
    @property
    def keys(self):
        return self._keys

    @keys.setter
    def keys(self, value):
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        cdef uint32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._keys = Uint32List(memview.size, listener=self)
            for i in range(memview.size):
                self._keys.append(memview[i])
            return
        self._keys = Uint32List(listener=self)
        for val in value:
            self._keys.append(val)
        self._Modified()
    
    @property
    def vals(self):
        return self._vals

    @vals.setter
    def vals(self, value):
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        cdef uint32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._vals = Uint32List(memview.size, listener=self)
            for i in range(memview.size):
                self._vals.append(memview[i])
            return
        self._vals = Uint32List(listener=self)
        for val in value:
            self._vals.append(val)
        self._Modified()
    
    @property
    def info(self):
        # lazy init sub messages
        if self._info is None:
            self._info = Info.__new__(Info)
            self._info.reset()
            self._info._listener = <PyObject *>self
        return self._info

    @info.setter
    def info(self, value):
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        self._info = value
        self._info._listener = <PyObject *>self
        self._Modified()
    
    @property
    def refs(self):
        return self._refs

    @refs.setter
    def refs(self, value):
        if self._refs is not None:
            self._refs._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._refs = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._refs.append(memview[i])
            return
        self._refs = Int64List(listener=self)
        for val in value:
            self._refs.append(val)
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef int64_t keys_marker
        cdef uint32_t keys_elt
        cdef int64_t vals_marker
        cdef uint32_t vals_elt
        cdef int64_t refs_marker
        cdef int64_t refs_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # id
            if key == 8:
                self.__field_bitmap0 |= 1
                self._id = get_varint64(memory, &current_offset)
            # keys
            elif key == 18:
                keys_marker = get_varint64(memory, &current_offset)
                keys_marker += current_offset

                while current_offset < <int>keys_marker:
                    keys_elt = get_varint32(memory, &current_offset)
                    self._keys._append(keys_elt)
            # vals
            elif key == 26:
                vals_marker = get_varint64(memory, &current_offset)
                vals_marker += current_offset

                while current_offset < <int>vals_marker:
                    vals_elt = get_varint32(memory, &current_offset)
                    self._vals._append(vals_elt)
            # info
            elif key == 34:
                field_size = get_varint64(memory, &current_offset)
                if self._info is None:
                    self._info = Info.__new__(Info)
                    self._info._listener = <PyObject *>self
                self._info.reset()
                if cache:
                    self._info._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._info._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # refs
            elif key == 66:
                refs_marker = get_varint64(memory, &current_offset)
                refs_marker += current_offset

                while current_offset < <int>refs_marker:
                    refs_elt = get_signed_varint64(memory, &current_offset)
                    self._refs._append(refs_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'id':
            self.__field_bitmap0 &= ~1
            self._id = 0
        elif field_name == 'keys':
            self._keys._listener = <PyObject *>null_listener
            self._keys = Uint32List.__new__(Uint32List)
            self._keys._listener = <PyObject *>self
        elif field_name == 'vals':
            self._vals._listener = <PyObject *>null_listener
            self._vals = Uint32List.__new__(Uint32List)
            self._vals._listener = <PyObject *>self
        elif field_name == 'info':
            if self._info is not None:
                self._info._listener = <PyObject *>null_listener
            self._info = None
        elif field_name == 'refs':
            self._refs._listener = <PyObject *>null_listener
            self._refs = Int64List.__new__(Int64List)
            self._refs._listener = <PyObject *>self
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, Way other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (Way): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'id':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'info':
            return self._info is not None and self._info._is_present_in_parent
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self.__field_bitmap0 & 1 != 1:
            return False
        if self._info is not None and self._info._is_present_in_parent and not self._info.IsInitialized():
            return False

        return True

    cpdef void MergeFrom(self, Way other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._id = other_msg._id
            self.__field_bitmap0 |= 1
        self._keys.extend(other_msg._keys)
        self._vals.extend(other_msg._vals)
        if other_msg._info is not None and other_msg._info._is_present_in_parent:
            if self._info is None:
                self._info = Info.__new__(Info)
                self._info.reset()
                self._info._listener = <PyObject *>self
            self._info.MergeFrom(other_msg._info)
        self._refs.extend(other_msg._refs)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # id
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_varint64(self._id, buf)
        # keys
        cdef uint32_t keys_elt
        cdef bytearray keys_buf = bytearray()
        length = len(self._keys)
        if length > 0:
            set_varint64(18, buf)
            for keys_elt in self._keys:
                set_varint32(keys_elt, keys_buf)

            set_varint64(len(keys_buf), buf)
            buf += keys_buf
        # vals
        cdef uint32_t vals_elt
        cdef bytearray vals_buf = bytearray()
        length = len(self._vals)
        if length > 0:
            set_varint64(26, buf)
            for vals_elt in self._vals:
                set_varint32(vals_elt, vals_buf)

            set_varint64(len(vals_buf), buf)
            buf += vals_buf
        # info
        cdef bytearray info_buf
        if self._info is not None and self._info._is_present_in_parent:
            set_varint64(34, buf)
            if self._info._cached_serialization is not None:
                set_varint64(len(self._info._cached_serialization), buf)
                buf += self._info._cached_serialization
            else:
                info_buf = bytearray()
                self._info._protobuf_serialize(info_buf, cache)
                set_varint64(len(info_buf), buf)
                buf += info_buf
                if cache:
                    self._info._cached_serialization = bytes(info_buf)
        # refs
        cdef int64_t refs_elt
        cdef bytearray refs_buf = bytearray()
        length = len(self._refs)
        if length > 0:
            set_varint64(66, buf)
            for refs_elt in self._refs:
                set_signed_varint64(refs_elt, refs_buf)

            set_varint64(len(refs_buf), buf)
            buf += refs_buf

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self._info is not None and self._info._is_present_in_parent and not self._info.IsInitialized():
            raise Exception("Message Way is missing required field: info")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.id = d["id"]
        except KeyError:
            pass
        try:
            self.keys = d["keys"]
        except KeyError:
            pass
        try:
            self.vals = d["vals"]
        except KeyError:
            pass
        try:
            self.info.ParseFromDict(d["info"])
        except KeyError:
            pass
        try:
            self.refs = d["refs"]
        except KeyError:
            pass

        self._Modified()
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if len(self.keys) > 0:
            out["keys"] = list(self.keys)
        if len(self.vals) > 0:
            out["vals"] = list(self.vals)
        info_dict = self.info.SerializeToDict()
        if info_dict != {}:
            out["info"] = info_dict
        if len(self.refs) > 0:
            out["refs"] = list(self.refs)

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if len(self.keys) > 0:
            out["keys"] = list(self.keys)
        if len(self.vals) > 0:
            out["vals"] = list(self.vals)
        info_dict = self.info.SerializePartialToDict()
        if info_dict != {}:
            out["info"] = info_dict
        if len(self.refs) > 0:
            out["refs"] = list(self.refs)

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'id', self.id
        yield 'keys', self.keys
        yield 'vals', self.vals
        yield 'info', self.info
        yield 'refs', self.refs

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'id'
        yield 'keys'
        yield 'vals'
        yield 'info'
        yield 'refs'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.id
        yield self.keys
        yield self.vals
        yield self.info
        yield self.refs

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.id = value
        yield setter
        def setter(value):
            self.keys = value
        yield setter
        def setter(value):
            self.vals = value
        yield setter
        def setter(value):
            self.info = value
        yield setter
        def setter(value):
            self.refs = value
        yield setter

    


cdef class Relation:

    def __cinit__(self):
        self._listener = <PyObject *>null_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        if self._roles_sid is not None:
            self._roles_sid._listener = <PyObject *>null_listener
        if self._memids is not None:
            self._memids._listener = <PyObject *>null_listener
        if self._types is not None:
            self._types._listener = <PyObject *>null_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('info',):
                        getattr(self, field_name).MergeFrom(field_value)
                    elif field_name in ('keys','vals','roles_sid','memids','types',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'id',
                          'keys',
                          'vals',
                          'roles_sid',
                          'memids',
                          'types',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'info',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    cpdef void reset(self):
        # reset values and populate defaults
    
        self.__field_bitmap0 = 0
    
        self._id = 0
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        self._keys = Uint32List.__new__(Uint32List)
        self._keys._listener = <PyObject *>self
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        self._vals = Uint32List.__new__(Uint32List)
        self._vals._listener = <PyObject *>self
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        self._info = None
        if self._roles_sid is not None:
            self._roles_sid._listener = <PyObject *>null_listener
        self._roles_sid = Int32List.__new__(Int32List)
        self._roles_sid._listener = <PyObject *>self
        if self._memids is not None:
            self._memids._listener = <PyObject *>null_listener
        self._memids = Int64List.__new__(Int64List)
        self._memids._listener = <PyObject *>self
        if self._types is not None:
            self._types._listener = <PyObject *>null_listener
        self._types = Int32List.__new__(Int32List)
        self._types._listener = <PyObject *>self
        return

    
    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, value):
        self.__field_bitmap0 |= 1
        self._id = value
        self._Modified()
    
    @property
    def keys(self):
        return self._keys

    @keys.setter
    def keys(self, value):
        if self._keys is not None:
            self._keys._listener = <PyObject *>null_listener
        cdef uint32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._keys = Uint32List(memview.size, listener=self)
            for i in range(memview.size):
                self._keys.append(memview[i])
            return
        self._keys = Uint32List(listener=self)
        for val in value:
            self._keys.append(val)
        self._Modified()
    
    @property
    def vals(self):
        return self._vals

    @vals.setter
    def vals(self, value):
        if self._vals is not None:
            self._vals._listener = <PyObject *>null_listener
        cdef uint32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._vals = Uint32List(memview.size, listener=self)
            for i in range(memview.size):
                self._vals.append(memview[i])
            return
        self._vals = Uint32List(listener=self)
        for val in value:
            self._vals.append(val)
        self._Modified()
    
    @property
    def info(self):
        # lazy init sub messages
        if self._info is None:
            self._info = Info.__new__(Info)
            self._info.reset()
            self._info._listener = <PyObject *>self
        return self._info

    @info.setter
    def info(self, value):
        if self._info is not None:
            self._info._listener = <PyObject *>null_listener
        self._info = value
        self._info._listener = <PyObject *>self
        self._Modified()
    
    @property
    def roles_sid(self):
        return self._roles_sid

    @roles_sid.setter
    def roles_sid(self, value):
        if self._roles_sid is not None:
            self._roles_sid._listener = <PyObject *>null_listener
        cdef int32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._roles_sid = Int32List(memview.size, listener=self)
            for i in range(memview.size):
                self._roles_sid.append(memview[i])
            return
        self._roles_sid = Int32List(listener=self)
        for val in value:
            self._roles_sid.append(val)
        self._Modified()
    
    @property
    def memids(self):
        return self._memids

    @memids.setter
    def memids(self, value):
        if self._memids is not None:
            self._memids._listener = <PyObject *>null_listener
        cdef int64_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._memids = Int64List(memview.size, listener=self)
            for i in range(memview.size):
                self._memids.append(memview[i])
            return
        self._memids = Int64List(listener=self)
        for val in value:
            self._memids.append(val)
        self._Modified()
    
    @property
    def types(self):
        return self._types

    @types.setter
    def types(self, value):
        if self._types is not None:
            self._types._listener = <PyObject *>null_listener
        cdef int32_t[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._types = Int32List(memview.size, listener=self)
            for i in range(memview.size):
                self._types.append(memview[i])
            return
        self._types = Int32List(listener=self)
        for val in value:
            if val == 0:
                self._types.append(_RelationMemberType_NODE)
                
            elif val == 1:
                self._types.append(_RelationMemberType_WAY)
                
            elif val == 2:
                self._types.append(_RelationMemberType_RELATION)
                
            else:
                raise ValueError("{} not a valid value for enum RelationMemberType".format(val))
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef int64_t keys_marker
        cdef uint32_t keys_elt
        cdef int64_t vals_marker
        cdef uint32_t vals_elt
        cdef int64_t roles_sid_marker
        cdef int32_t roles_sid_elt
        cdef int64_t memids_marker
        cdef int64_t memids_elt
        cdef int64_t types_marker
        cdef int32_t types_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # id
            if key == 8:
                self.__field_bitmap0 |= 1
                self._id = get_varint64(memory, &current_offset)
            # keys
            elif key == 18:
                keys_marker = get_varint64(memory, &current_offset)
                keys_marker += current_offset

                while current_offset < <int>keys_marker:
                    keys_elt = get_varint32(memory, &current_offset)
                    self._keys._append(keys_elt)
            # vals
            elif key == 26:
                vals_marker = get_varint64(memory, &current_offset)
                vals_marker += current_offset

                while current_offset < <int>vals_marker:
                    vals_elt = get_varint32(memory, &current_offset)
                    self._vals._append(vals_elt)
            # info
            elif key == 34:
                field_size = get_varint64(memory, &current_offset)
                if self._info is None:
                    self._info = Info.__new__(Info)
                    self._info._listener = <PyObject *>self
                self._info.reset()
                if cache:
                    self._info._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += self._info._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
            # roles_sid
            elif key == 66:
                roles_sid_marker = get_varint64(memory, &current_offset)
                roles_sid_marker += current_offset

                while current_offset < <int>roles_sid_marker:
                    roles_sid_elt = get_varint32(memory, &current_offset)
                    self._roles_sid._append(roles_sid_elt)
            # memids
            elif key == 74:
                memids_marker = get_varint64(memory, &current_offset)
                memids_marker += current_offset

                while current_offset < <int>memids_marker:
                    memids_elt = get_signed_varint64(memory, &current_offset)
                    self._memids._append(memids_elt)
            # types
            elif key == 82:
                types_marker = get_varint64(memory, &current_offset)
                types_marker += current_offset

                while current_offset < <int>types_marker:
                    types_elt = get_varint32(memory, &current_offset)
                    self._types._append(types_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        if field_name == 'id':
            self.__field_bitmap0 &= ~1
            self._id = 0
        elif field_name == 'keys':
            self._keys._listener = <PyObject *>null_listener
            self._keys = Uint32List.__new__(Uint32List)
            self._keys._listener = <PyObject *>self
        elif field_name == 'vals':
            self._vals._listener = <PyObject *>null_listener
            self._vals = Uint32List.__new__(Uint32List)
            self._vals._listener = <PyObject *>self
        elif field_name == 'info':
            if self._info is not None:
                self._info._listener = <PyObject *>null_listener
            self._info = None
        elif field_name == 'roles_sid':
            self._roles_sid._listener = <PyObject *>null_listener
            self._roles_sid = Int32List.__new__(Int32List)
            self._roles_sid._listener = <PyObject *>self
        elif field_name == 'memids':
            self._memids._listener = <PyObject *>null_listener
            self._memids = Int64List.__new__(Int64List)
            self._memids._listener = <PyObject *>self
        elif field_name == 'types':
            self._types._listener = <PyObject *>null_listener
            self._types = Int32List.__new__(Int32List)
            self._types._listener = <PyObject *>self
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

        self._Modified()

    cpdef void CopyFrom(self, Relation other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (Relation): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'id':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'info':
            return self._info is not None and self._info._is_present_in_parent
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    
        if self.__field_bitmap0 & 1 != 1:
            return False
        if self._info is not None and self._info._is_present_in_parent and not self._info.IsInitialized():
            return False

        return True

    cpdef void MergeFrom(self, Relation other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._id = other_msg._id
            self.__field_bitmap0 |= 1
        self._keys.extend(other_msg._keys)
        self._vals.extend(other_msg._vals)
        if other_msg._info is not None and other_msg._info._is_present_in_parent:
            if self._info is None:
                self._info = Info.__new__(Info)
                self._info.reset()
                self._info._listener = <PyObject *>self
            self._info.MergeFrom(other_msg._info)
        self._roles_sid.extend(other_msg._roles_sid)
        self._memids.extend(other_msg._memids)
        self._types.extend(other_msg._types)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # id
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_varint64(self._id, buf)
        # keys
        cdef uint32_t keys_elt
        cdef bytearray keys_buf = bytearray()
        length = len(self._keys)
        if length > 0:
            set_varint64(18, buf)
            for keys_elt in self._keys:
                set_varint32(keys_elt, keys_buf)

            set_varint64(len(keys_buf), buf)
            buf += keys_buf
        # vals
        cdef uint32_t vals_elt
        cdef bytearray vals_buf = bytearray()
        length = len(self._vals)
        if length > 0:
            set_varint64(26, buf)
            for vals_elt in self._vals:
                set_varint32(vals_elt, vals_buf)

            set_varint64(len(vals_buf), buf)
            buf += vals_buf
        # info
        cdef bytearray info_buf
        if self._info is not None and self._info._is_present_in_parent:
            set_varint64(34, buf)
            if self._info._cached_serialization is not None:
                set_varint64(len(self._info._cached_serialization), buf)
                buf += self._info._cached_serialization
            else:
                info_buf = bytearray()
                self._info._protobuf_serialize(info_buf, cache)
                set_varint64(len(info_buf), buf)
                buf += info_buf
                if cache:
                    self._info._cached_serialization = bytes(info_buf)
        # roles_sid
        cdef int32_t roles_sid_elt
        cdef bytearray roles_sid_buf = bytearray()
        length = len(self._roles_sid)
        if length > 0:
            set_varint64(66, buf)
            for roles_sid_elt in self._roles_sid:
                set_varint32(roles_sid_elt, roles_sid_buf)

            set_varint64(len(roles_sid_buf), buf)
            buf += roles_sid_buf
        # memids
        cdef int64_t memids_elt
        cdef bytearray memids_buf = bytearray()
        length = len(self._memids)
        if length > 0:
            set_varint64(74, buf)
            for memids_elt in self._memids:
                set_signed_varint64(memids_elt, memids_buf)

            set_varint64(len(memids_buf), buf)
            buf += memids_buf
        # types
        cdef int32_t types_elt
        cdef bytearray types_buf = bytearray()
        length = len(self._types)
        if length > 0:
            set_varint64(82, buf)
            for types_elt in self._types:
                set_varint32(types_elt, types_buf)

            set_varint64(len(types_buf), buf)
            buf += types_buf

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        (<object> self._listener)._Modified()
        self._cached_serialization = None

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self._info is not None and self._info._is_present_in_parent and not self._info.IsInitialized():
            raise Exception("Message Relation is missing required field: info")

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.id = d["id"]
        except KeyError:
            pass
        try:
            self.keys = d["keys"]
        except KeyError:
            pass
        try:
            self.vals = d["vals"]
        except KeyError:
            pass
        try:
            self.info.ParseFromDict(d["info"])
        except KeyError:
            pass
        try:
            self.roles_sid = d["roles_sid"]
        except KeyError:
            pass
        try:
            self.memids = d["memids"]
        except KeyError:
            pass
        try:
            self.types = d["types"]
        except KeyError:
            pass

        self._Modified()
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 != 1:
            raise Exception("required field 'id' not initialized and does not have default")
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if len(self.keys) > 0:
            out["keys"] = list(self.keys)
        if len(self.vals) > 0:
            out["vals"] = list(self.vals)
        info_dict = self.info.SerializeToDict()
        if info_dict != {}:
            out["info"] = info_dict
        if len(self.roles_sid) > 0:
            out["roles_sid"] = list(self.roles_sid)
        if len(self.memids) > 0:
            out["memids"] = list(self.memids)
        if len(self.types) > 0:
            out["types"] = list(self.types)

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["id"] = self.id
        if len(self.keys) > 0:
            out["keys"] = list(self.keys)
        if len(self.vals) > 0:
            out["vals"] = list(self.vals)
        info_dict = self.info.SerializePartialToDict()
        if info_dict != {}:
            out["info"] = info_dict
        if len(self.roles_sid) > 0:
            out["roles_sid"] = list(self.roles_sid)
        if len(self.memids) > 0:
            out["memids"] = list(self.memids)
        if len(self.types) > 0:
            out["types"] = list(self.types)

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'id', self.id
        yield 'keys', self.keys
        yield 'vals', self.vals
        yield 'info', self.info
        yield 'roles_sid', self.roles_sid
        yield 'memids', self.memids
        yield 'types', self.types

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'id'
        yield 'keys'
        yield 'vals'
        yield 'info'
        yield 'roles_sid'
        yield 'memids'
        yield 'types'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.id
        yield self.keys
        yield self.vals
        yield self.info
        yield self.roles_sid
        yield self.memids
        yield self.types

    
        
    NODE = _RelationMemberType_NODE
    WAY = _RelationMemberType_WAY
    RELATION = _RelationMemberType_RELATION
    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.id = value
        yield setter
        def setter(value):
            self.keys = value
        yield setter
        def setter(value):
            self.vals = value
        yield setter
        def setter(value):
            self.info = value
        yield setter
        def setter(value):
            self.roles_sid = value
        yield setter
        def setter(value):
            self.memids = value
        yield setter
        def setter(value):
            self.types = value
        yield setter

    

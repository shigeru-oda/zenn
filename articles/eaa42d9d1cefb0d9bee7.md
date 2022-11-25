---
title: "pandas.read_csv(s3)が上手く稼働しないので整理"
emoji: "🚴🏻‍♀️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["aws","座学","調べ物"]
published: true
---
# はじめに
データ解析用ライブラリであるpandasにread_csvという機能がある。これはローカルファイルだけではなく、S3のアドレス(s3://bucket/key)でも読み込みすることが出来るようである。  
  
しかし作業中にエラーになったので、何が間違っているのかを探すための整理資料です。

# 結論
自分の環境だけかもですが、S3直接アドレスでのread_csvは動きませんでした。
回避策はstackoverflowの記事参照
https://stackoverflow.com/questions/35803601/reading-a-file-from-a-private-s3-bucket-to-a-pandas-dataframe

# 手順
## SageMakerでのnotebookで環境準備
ライブラリをインストール
```
%pip install -q pandas boto3 boto
```

importを行いVersion確認
```
import pandas as pd
import boto3
import boto

print(pd.__version__,boto3.__version__,boto.__version__)
```

結果
```
1.3.5 1.26.8 2.49.0
```

s3のURIを設定、train_uriがAWSが公開している他アカウント、s3_uriが自アカウント
```
train_uri='s3://sagemaker-sample-files/datasets/tabular/synthetic_automobile_claims/train.csv'
s3_uri='s3://sagemaker-us-east-1-123456789012/hoge.csv'
```

## 権限周り確認 Role
aws cliでの確認
```
!aws sts get-caller-identity
```

結果 -> 想定通り
```
{
    "UserId": "AROAVQKJMMMINPTNJDIME:SageMaker",
    "Account": "123456789012",
    "Arn": "arn:aws:sts::123456789012:assumed-role/AmazonSageMaker-ExecutionRole-20221117T213439/SageMaker"
}
```

boto3での確認
```
boto3.client('sts').get_caller_identity()
```

結果 -> 想定通り
```
{'UserId': 'AROAVQKJMMMINPTNJDIME:SageMaker',
 'Account': '123456789012',
 'Arn': 'arn:aws:sts::123456789012:assumed-role/AmazonSageMaker-ExecutionRole-20221117T213439/SageMaker',
 'ResponseMetadata': {'RequestId': '927ac2b8-e60c-4351-9055-0af66ceb771b',
  'HTTPStatusCode': 200,
  'HTTPHeaders': {'x-amzn-requestid': '927ac2b8-e60c-4351-9055-0af66ceb771b',
   'content-type': 'text/xml',
   'content-length': '470',
   'date': 'Fri, 25 Nov 2022 12:44:43 GMT'},
  'RetryAttempts': 0}}
```

## 権限周り確認 s3 cp
自アカウントのS3からDownLoad確認
```
!aws s3 cp {s3_uri} ./
```

結果 -> DownLoad OK(Role上は問題なし)
```
download: s3://sagemaker-us-east-1-123456789012/hoge.csv to ./hoge.csv
```

他アカウントのS3からDownLoad確認
```
!aws s3 cp {train_uri} ./
```

結果 -> DownLoad OK(Role上は問題なし)
```
download: s3://sagemaker-sample-files/datasets/tabular/synthetic_automobile_claims/train.csv to ./train.csv
```

## pandas.read_csvでの動作確認
自アカウントのS3からread_csv
```
pd.read_csv(s3_uri)
```

結果 -> NG(FileNotFoundError)

:::details エラー内容
```
/opt/conda/lib/python3.7/site-packages/botocore/utils.py:1723: FutureWarning: The S3RegionRedirector class has been deprecated for a new internal replacement. A future version of botocore may remove this class.
  category=FutureWarning,
---------------------------------------------------------------------------
FileNotFoundError                         Traceback (most recent call last)
<ipython-input-28-aaae9b8f850a> in <module>
----> 1 pd.read_csv(s3_uri)

/opt/conda/lib/python3.7/site-packages/pandas/util/_decorators.py in wrapper(*args, **kwargs)
    309                     stacklevel=stacklevel,
    310                 )
--> 311             return func(*args, **kwargs)
    312 
    313         return wrapper

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in read_csv(filepath_or_buffer, sep, delimiter, header, names, index_col, usecols, squeeze, prefix, mangle_dupe_cols, dtype, engine, converters, true_values, false_values, skipinitialspace, skiprows, skipfooter, nrows, na_values, keep_default_na, na_filter, verbose, skip_blank_lines, parse_dates, infer_datetime_format, keep_date_col, date_parser, dayfirst, cache_dates, iterator, chunksize, compression, thousands, decimal, lineterminator, quotechar, quoting, doublequote, escapechar, comment, encoding, encoding_errors, dialect, error_bad_lines, warn_bad_lines, on_bad_lines, delim_whitespace, low_memory, memory_map, float_precision, storage_options)
    584     kwds.update(kwds_defaults)
    585 
--> 586     return _read(filepath_or_buffer, kwds)
    587 
    588 

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in _read(filepath_or_buffer, kwds)
    480 
    481     # Create the parser.
--> 482     parser = TextFileReader(filepath_or_buffer, **kwds)
    483 
    484     if chunksize or iterator:

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in __init__(self, f, engine, **kwds)
    809             self.options["has_index_names"] = kwds["has_index_names"]
    810 
--> 811         self._engine = self._make_engine(self.engine)
    812 
    813     def close(self):

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in _make_engine(self, engine)
   1038             )
   1039         # error: Too many arguments for "ParserBase"
-> 1040         return mapping[engine](self.f, **self.options)  # type: ignore[call-arg]
   1041 
   1042     def _failover_to_python(self):

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/c_parser_wrapper.py in __init__(self, src, **kwds)
     49 
     50         # open handles
---> 51         self._open_handles(src, kwds)
     52         assert self.handles is not None
     53 

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/base_parser.py in _open_handles(self, src, kwds)
    227             memory_map=kwds.get("memory_map", False),
    228             storage_options=kwds.get("storage_options", None),
--> 229             errors=kwds.get("encoding_errors", "strict"),
    230         )
    231 

/opt/conda/lib/python3.7/site-packages/pandas/io/common.py in get_handle(path_or_buf, mode, encoding, compression, memory_map, is_text, errors, storage_options)
    612         compression=compression,
    613         mode=mode,
--> 614         storage_options=storage_options,
    615     )
    616 

/opt/conda/lib/python3.7/site-packages/pandas/io/common.py in _get_filepath_or_buffer(filepath_or_buffer, encoding, compression, mode, storage_options)
    357         try:
    358             file_obj = fsspec.open(
--> 359                 filepath_or_buffer, mode=fsspec_mode, **(storage_options or {})
    360             ).open()
    361         # GH 34626 Reads from Public Buckets without Credentials needs anon=True

/opt/conda/lib/python3.7/site-packages/fsspec/core.py in open(self)
    133         during the life of the file-like it generates.
    134         """
--> 135         return self.__enter__()
    136 
    137     def close(self):

/opt/conda/lib/python3.7/site-packages/fsspec/core.py in __enter__(self)
    101         mode = self.mode.replace("t", "").replace("b", "") + "b"
    102 
--> 103         f = self.fs.open(self.path, mode=mode)
    104 
    105         self.fobjects = [f]

/opt/conda/lib/python3.7/site-packages/fsspec/spec.py in open(self, path, mode, block_size, cache_options, compression, **kwargs)
   1110                 autocommit=ac,
   1111                 cache_options=cache_options,
-> 1112                 **kwargs,
   1113             )
   1114             if compression is not None:

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _open(self, path, mode, block_size, acl, version_id, fill_cache, cache_type, autocommit, requester_pays, cache_options, **kwargs)
    650             autocommit=autocommit,
    651             requester_pays=requester_pays,
--> 652             cache_options=cache_options,
    653         )
    654 

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in __init__(self, s3, path, mode, block_size, acl, version_id, fill_cache, s3_additional_kwargs, autocommit, cache_type, requester_pays, cache_options)
   1994             autocommit=autocommit,
   1995             cache_type=cache_type,
-> 1996             cache_options=cache_options,
   1997         )
   1998         self.s3 = self.fs  # compatibility

/opt/conda/lib/python3.7/site-packages/fsspec/spec.py in __init__(self, fs, path, mode, block_size, autocommit, cache_type, cache_options, size, **kwargs)
   1460                 self.size = size
   1461             else:
-> 1462                 self.size = self.details["size"]
   1463             self.cache = caches[cache_type](
   1464                 self.blocksize, self._fetch_range, self.size, **cache_options

/opt/conda/lib/python3.7/site-packages/fsspec/spec.py in details(self)
   1473     def details(self):
   1474         if self._details is None:
-> 1475             self._details = self.fs.info(self.path)
   1476         return self._details
   1477 

/opt/conda/lib/python3.7/site-packages/fsspec/asyn.py in wrapper(*args, **kwargs)
    111     def wrapper(*args, **kwargs):
    112         self = obj or args[0]
--> 113         return sync(self.loop, func, *args, **kwargs)
    114 
    115     return wrapper

/opt/conda/lib/python3.7/site-packages/fsspec/asyn.py in sync(loop, func, timeout, *args, **kwargs)
     96         raise FSTimeoutError from return_result
     97     elif isinstance(return_result, BaseException):
---> 98         raise return_result
     99     else:
    100         return return_result

/opt/conda/lib/python3.7/site-packages/fsspec/asyn.py in _runner(event, coro, result, timeout)
     51         coro = asyncio.wait_for(coro, timeout=timeout)
     52     try:
---> 53         result[0] = await coro
     54     except Exception as ex:
     55         result[0] = ex

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _info(self, path, bucket, key, refresh, version_id)
   1255                 }
   1256 
-> 1257             raise FileNotFoundError(path)
   1258         except ClientError as e:
   1259             raise translate_boto_error(e, set_cause=False)

FileNotFoundError: sagemaker-us-east-1-123456789012/hoge.csv
```
:::


他アカウントのS3からread_csv
```
pd.read_csv(train_uri)
```

結果 -> NG(Forbidden)

:::details エラー内容
```
ClientError                               Traceback (most recent call last)
/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _error_wrapper(func, args, kwargs, retries)
    111         try:
--> 112             return await func(*args, **kwargs)
    113         except S3_RETRYABLE_ERRORS as e:

/opt/conda/lib/python3.7/site-packages/aiobotocore/client.py in _make_api_call(self, operation_name, api_params)
    357             error_class = self.exceptions.from_code(error_code)
--> 358             raise error_class(parsed_response, operation_name)
    359         else:

ClientError: An error occurred (403) when calling the HeadObject operation: Forbidden

The above exception was the direct cause of the following exception:

PermissionError                           Traceback (most recent call last)
<ipython-input-30-f73410c96a01> in <module>
----> 1 pd.read_csv(train_uri)

/opt/conda/lib/python3.7/site-packages/pandas/util/_decorators.py in wrapper(*args, **kwargs)
    309                     stacklevel=stacklevel,
    310                 )
--> 311             return func(*args, **kwargs)
    312 
    313         return wrapper

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in read_csv(filepath_or_buffer, sep, delimiter, header, names, index_col, usecols, squeeze, prefix, mangle_dupe_cols, dtype, engine, converters, true_values, false_values, skipinitialspace, skiprows, skipfooter, nrows, na_values, keep_default_na, na_filter, verbose, skip_blank_lines, parse_dates, infer_datetime_format, keep_date_col, date_parser, dayfirst, cache_dates, iterator, chunksize, compression, thousands, decimal, lineterminator, quotechar, quoting, doublequote, escapechar, comment, encoding, encoding_errors, dialect, error_bad_lines, warn_bad_lines, on_bad_lines, delim_whitespace, low_memory, memory_map, float_precision, storage_options)
    584     kwds.update(kwds_defaults)
    585 
--> 586     return _read(filepath_or_buffer, kwds)
    587 
    588 

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in _read(filepath_or_buffer, kwds)
    480 
    481     # Create the parser.
--> 482     parser = TextFileReader(filepath_or_buffer, **kwds)
    483 
    484     if chunksize or iterator:

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in __init__(self, f, engine, **kwds)
    809             self.options["has_index_names"] = kwds["has_index_names"]
    810 
--> 811         self._engine = self._make_engine(self.engine)
    812 
    813     def close(self):

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/readers.py in _make_engine(self, engine)
   1038             )
   1039         # error: Too many arguments for "ParserBase"
-> 1040         return mapping[engine](self.f, **self.options)  # type: ignore[call-arg]
   1041 
   1042     def _failover_to_python(self):

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/c_parser_wrapper.py in __init__(self, src, **kwds)
     49 
     50         # open handles
---> 51         self._open_handles(src, kwds)
     52         assert self.handles is not None
     53 

/opt/conda/lib/python3.7/site-packages/pandas/io/parsers/base_parser.py in _open_handles(self, src, kwds)
    227             memory_map=kwds.get("memory_map", False),
    228             storage_options=kwds.get("storage_options", None),
--> 229             errors=kwds.get("encoding_errors", "strict"),
    230         )
    231 

/opt/conda/lib/python3.7/site-packages/pandas/io/common.py in get_handle(path_or_buf, mode, encoding, compression, memory_map, is_text, errors, storage_options)
    612         compression=compression,
    613         mode=mode,
--> 614         storage_options=storage_options,
    615     )
    616 

/opt/conda/lib/python3.7/site-packages/pandas/io/common.py in _get_filepath_or_buffer(filepath_or_buffer, encoding, compression, mode, storage_options)
    368                 storage_options["anon"] = True
    369             file_obj = fsspec.open(
--> 370                 filepath_or_buffer, mode=fsspec_mode, **(storage_options or {})
    371             ).open()
    372 

/opt/conda/lib/python3.7/site-packages/fsspec/core.py in open(self)
    133         during the life of the file-like it generates.
    134         """
--> 135         return self.__enter__()
    136 
    137     def close(self):

/opt/conda/lib/python3.7/site-packages/fsspec/core.py in __enter__(self)
    101         mode = self.mode.replace("t", "").replace("b", "") + "b"
    102 
--> 103         f = self.fs.open(self.path, mode=mode)
    104 
    105         self.fobjects = [f]

/opt/conda/lib/python3.7/site-packages/fsspec/spec.py in open(self, path, mode, block_size, cache_options, compression, **kwargs)
   1110                 autocommit=ac,
   1111                 cache_options=cache_options,
-> 1112                 **kwargs,
   1113             )
   1114             if compression is not None:

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _open(self, path, mode, block_size, acl, version_id, fill_cache, cache_type, autocommit, requester_pays, cache_options, **kwargs)
    650             autocommit=autocommit,
    651             requester_pays=requester_pays,
--> 652             cache_options=cache_options,
    653         )
    654 

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in __init__(self, s3, path, mode, block_size, acl, version_id, fill_cache, s3_additional_kwargs, autocommit, cache_type, requester_pays, cache_options)
   1994             autocommit=autocommit,
   1995             cache_type=cache_type,
-> 1996             cache_options=cache_options,
   1997         )
   1998         self.s3 = self.fs  # compatibility

/opt/conda/lib/python3.7/site-packages/fsspec/spec.py in __init__(self, fs, path, mode, block_size, autocommit, cache_type, cache_options, size, **kwargs)
   1460                 self.size = size
   1461             else:
-> 1462                 self.size = self.details["size"]
   1463             self.cache = caches[cache_type](
   1464                 self.blocksize, self._fetch_range, self.size, **cache_options

/opt/conda/lib/python3.7/site-packages/fsspec/spec.py in details(self)
   1473     def details(self):
   1474         if self._details is None:
-> 1475             self._details = self.fs.info(self.path)
   1476         return self._details
   1477 

/opt/conda/lib/python3.7/site-packages/fsspec/asyn.py in wrapper(*args, **kwargs)
    111     def wrapper(*args, **kwargs):
    112         self = obj or args[0]
--> 113         return sync(self.loop, func, *args, **kwargs)
    114 
    115     return wrapper

/opt/conda/lib/python3.7/site-packages/fsspec/asyn.py in sync(loop, func, timeout, *args, **kwargs)
     96         raise FSTimeoutError from return_result
     97     elif isinstance(return_result, BaseException):
---> 98         raise return_result
     99     else:
    100         return return_result

/opt/conda/lib/python3.7/site-packages/fsspec/asyn.py in _runner(event, coro, result, timeout)
     51         coro = asyncio.wait_for(coro, timeout=timeout)
     52     try:
---> 53         result[0] = await coro
     54     except Exception as ex:
     55         result[0] = ex

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _info(self, path, bucket, key, refresh, version_id)
   1214                     Key=key,
   1215                     **version_id_kw(version_id),
-> 1216                     **self.req_kw,
   1217                 )
   1218                 return {

/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _call_s3(self, method, *akwarglist, **kwargs)
    338         additional_kwargs = self._get_s3_method_kwargs(method, *akwarglist, **kwargs)
    339         return await _error_wrapper(
--> 340             method, kwargs=additional_kwargs, retries=self.retries
    341         )
    342
​
/opt/conda/lib/python3.7/site-packages/s3fs/core.py in _error_wrapper(func, args, kwargs, retries)
    137             err = e
    138     err = translate_boto_error(err)
--> 139     raise err
    140 
    141 
PermissionError: Forbidden
```
:::



## stackoverflowの記事
https://stackoverflow.com/questions/35803601/reading-a-file-from-a-private-s3-bucket-to-a-pandas-dataframe

Pandas uses boto (not boto3) inside read_csv. You might be able to install boto and have it work correctly.
とあるけど、botoはimport済でもエラーを吐く。



## s3fsのinstall
stackoverflowにIf you have already installed s3fs (pip install s3fs) then you can read the file directly from s3 path, without any imports:
とあるので、こちらを試してみる。

s3fsのinstall
```
%pip install -q s3fs
```


importを行いVersion確認
```
import s3fs

print(pd.__version__,boto3.__version__,boto.__version__,s3fs.__version__)
```

結果
```
1.3.5 1.26.8 2.49.0 2022.11.0
```

S3からread_csv
```
pd.read_csv(s3_uri)
pd.read_csv(train_uri)
```

結果はNGで内容は変わらず・・・

## boto3でのobjectにpandas.read_csvでの動作確認
自アカウントのS3からread_csv

```
s3 = boto3.client('s3')
obj = s3.get_object(Bucket='sagemaker-us-east-1-123456789012', Key='hoge.csv')
pd.read_csv(obj['Body'])
```

結果 -> OK
```
1,2,3
```

他アカウントのS3からread_csv

```
s3 = boto3.client('s3')
obj = s3.get_object(Bucket='sagemaker-sample-files', Key='datasets/tabular/synthetic_automobile_claims/train.csv')
pd.read_csv(obj['Body'])
```

結果 -> OK
![](https://storage.googleapis.com/zenn-user-upload/4d81f1c2e37e-20221125.png)
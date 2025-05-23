﻿using eSpa.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eSpa.Service
{
    public interface IService<T,TSearch> where T : class where TSearch : class
    {
        Task<PagedResult<T>> Get(TSearch? search=null);
        Task<T> GetById(int id);
    }
}
